//
//  CreateChatViewController.swift
//  Connect
//
//  Created by Leandro Diaz on 2/7/21.
//

import UIKit

class CreateChatViewController: UIViewController {
    public var completion: ((UserProfile) -> (Void))?
    private var tableView: UITableView?
    private var users = [UserProfile]()
    private var filteredUsers = [UserProfile]()
    private var hasFetched = false
    private var database = MessagesManager.shared
    private var persistenceManager = PersistenceManager.shared
    private var usersManager = UserManager.shared
    
    private let noResultsLabel = CustomSecondaryTitleLabel(title: "No results for that search", fontSize: 16, textColor: .lightText)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureUI()
        configureNavigationBar()
        view.backgroundColor = .systemRed
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    private func configureNavigationBar() {
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = cancelBtn
    
        guard let currentUser = usersManager.currentUserProfile else { return }
            let profileView = CustomProfileView(frame: .zero, profilePic: currentUser.profileImage, userName: currentUser.name)
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(profileView)
            profileView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant:  -20).isActive = true
            self.navigationItem.titleView = containerView
        
        filterSearch()
    }
    
    //filter search function
    func filterSearch(){
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Find Friend"
        search.searchResultsUpdater = self
        search.delegate = self
        navigationItem.searchController = search
        search.becomeFirstResponder()
        search.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController = search
    }
    
    private func configureUI() {
        noResultsLabel.textAlignment = .center
        noResultsLabel.isHidden = true
        view.bringSubviewToFront(noResultsLabel)
        view.addSubview(noResultsLabel)
        setupConstraints()
    }
    
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.frame = view.bounds
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView?.allowsSelection = true
        tableView?.removeEmptyCells()
        
        guard let tableView = tableView else { return}
        view.addSubview(tableView)
    }
    
    
    private func setupConstraints() {
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            noResultsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            noResultsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            noResultsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    @objc private func dismissVC() {
        self.dismiss(animated: true) {
        }
    }
    
    
}

//MARK:- TABLE VIEW DELEGATES

extension CreateChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let user = filteredUsers[indexPath.row]
        
        cell.textLabel?.text = "\(user.name), \(user.email)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedUser = filteredUsers[indexPath.row]
        print("selected")
        if selectedUser.userID == self.usersManager.currentUserProfile?.userID {
            self.showAlert(title: "Wrong User...", message: "Hey, you can't message you self, please choose another recipient", buttonTitle: "Thank you..")
            return
        } else {
            self.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.completion?(selectedUser)
            }
        }
    }
}

//MARK:- SEARCH FUNCTIONALITY
extension CreateChatViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 0 {
            let query = text.replacingOccurrences(of: " ", with: "")
            self.filteredUsers.removeAll()
            
            self.showLoadingView()
            if hasFetched {
                self.dismissLoadingView()
                self.filteredUsers = users.filter({
                    let name = $0.name.lowercased().contains(query.lowercased())
                    return name
                })
                updateOnResults()
            } else {
                self.database.getChatUsers { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let data):
                        self.dismissLoadingView()
                        self.hasFetched = true
                        guard let user = data else { return }
                        self.users.append(contentsOf: user)
                        self.dismissLoadingView()
                        for singleUser in user {
                            if !self.filteredUsers.contains(singleUser){
                                self.filteredUsers = self.users.filter({
                                    let name = $0.name.lowercased().contains(query.lowercased())
                                    return name
                                })
                            }
                            self.persistenceManager.saveUserToDeviceCache(user: singleUser) { result in
                                print(result)
                                print("on filtered array the user ",singleUser)
                            }
                        }
                        self.updateOnResults()
                    case .failure(let error):
                        self.noResultsLabel.text = error.rawValue
                    }
                }
            }
        }
    }
    
    private func updateOnResults() {
        self.dismissLoadingView()
        if self.filteredUsers.isEmpty {
            self.noResultsLabel.isHidden = false
            self.tableView?.isHidden = true
        } else {
            self.noResultsLabel.isHidden = true
            self.tableView?.isHidden = false
            self.tableView?.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("ajaaaa")
    }
}


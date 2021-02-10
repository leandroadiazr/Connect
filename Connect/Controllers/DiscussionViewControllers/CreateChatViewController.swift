//
//  CreateChatViewController.swift
//  Connect
//
//  Created by Leandro Diaz on 2/7/21.
//

import UIKit

class CreateChatViewController: UIViewController {
    
    var tableView: UITableView?
    var generics = [String]()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Choose a Contact"
        return searchBar
    }()
    
    private let noResultsLabel = CustomSecondaryTitleLabel(title: "No results for that search", fontSize: 16, textColor: .lightText)
    
    override func viewDidLoad() {
        super.viewDidLoad()
                configureTableView()
        configureUI()
        configureNavigationBar()
        view.backgroundColor = .systemRed
    }
    
    private func configureNavigationBar() {
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        navigationController?.navigationBar.topItem?.titleView = searchBar
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = cancelBtn
    }
    
    private func configureSearchBar() {
        
    }
    
   @objc private func newChatTableView() {
        
    }
    
    private func configureUI() {
        noResultsLabel.textAlignment = .center
        view.bringSubviewToFront(noResultsLabel)
        view.addSubview(noResultsLabel)
        
        setupConstraints()
    }
    
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.frame = view.bounds
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = .systemBlue
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
//            self.dismissLoadingView()
        }
    }
    
    
}

extension CreateChatViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("ajaaaa")
    }
}

extension CreateChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return generics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = generics[indexPath.row]
        if item.isEmpty {
            self.showEmptyState(with: "No Users yet, Please add few friends...", in: view)
        } else {
            cell.textLabel?.text = item
            return cell
        }
        return cell
    }
}



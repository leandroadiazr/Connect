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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
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
    
    @objc private func dismissVC() {
        self.dismiss(animated: true) {
            self.dismissLoadingView()
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

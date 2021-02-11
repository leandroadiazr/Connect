//
//  DiscussionViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/17/21.
//

import UIKit

class DiscussionViewController: UIViewController {
    
    var tableView: UITableView?
    var discussions = [UserProfile]()
    var user: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = user else { return }
        if !discussions.contains(user) {
            discussions.append(user)
        }
        self.tableView?.reloadData()
    }
    private func configureNavigationBar() {
        let addChat = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewChat))
        navigationItem.rightBarButtonItem = addChat
    }
    
    @objc private func createNewChat() {
        let createVC = CreateChatViewController()
        createVC.completion = {[weak self] user in
            print(user)
            self?.createNewConversation(result: user)
        }
        
        let navVC = UINavigationController(rootViewController: createVC)
        navVC.modalPresentationStyle = .automatic
        self.present(navVC, animated: true, completion: nil)
    }
    
    private func createNewConversation(result: UserProfile?) {
        guard let name = result?.name, let email = result?.email else { return }
        let chatVC = ChatViewController(with: email)
        chatVC.isNewConversation = true
        chatVC.title = name
        let navVC = UINavigationController(rootViewController: chatVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
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
    
    private func fetchConversations() {
    }
}

extension DiscussionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discussions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = discussions[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentDiscusion = discussions[indexPath.row]
        let chatVC = ChatViewController(with: currentDiscusion.email)
        chatVC.userProfile.append(currentDiscusion)
        let navVC = UINavigationController(rootViewController: chatVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
        
    }
}

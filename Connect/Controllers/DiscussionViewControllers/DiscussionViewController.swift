//
//  DiscussionViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/17/21.
//

import UIKit

class DiscussionViewController: UIViewController {
    
    var tableView: UITableView?
    var generics = ["String","String","String","String","String",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
    }
    private func configureNavigationBar() {
        //        let titleImageView = UIImageView(image: Images.like)
        //        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        //        titleImageView.contentMode = .scaleAspectFit
        //        titleImageView.tintColor = .blue
        //        navigationItem.title = updateTitle
        let addChat = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewChat))
        navigationItem.rightBarButtonItem = addChat
    }
    
    @objc private func createNewChat() {
        let createVC = CreateChatViewController()
        let navVC = UINavigationController(rootViewController: createVC)
        navVC.modalPresentationStyle = .automatic
        self.present(navVC, animated: true, completion: nil)
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
        //        showLoadingView()
    }
}

extension DiscussionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return generics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = generics[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        _ = generics[indexPath.row]
        print(indexPath.row)
        let chatVC = ChatViewController()
        let navVC = UINavigationController(rootViewController: chatVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
        
    }
}

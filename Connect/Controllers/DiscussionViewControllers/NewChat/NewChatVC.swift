//
//  NewChatVC.swift
//  Connect
//
//  Created by Leandro Diaz on 2/9/21.
//

import UIKit

class NewChatVC: UIViewController {

    var tableView: UITableView?
    var generics = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        configureTableView()
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.frame = view.bounds
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = .systemBlue
        
        guard let tableView = tableView else { return}
        view.addSubview(tableView)
    }
    
    
    
}

extension NewChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return generics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = generics[indexPath.row]
        
        cell.textLabel?.text = item
        return cell
    }
}



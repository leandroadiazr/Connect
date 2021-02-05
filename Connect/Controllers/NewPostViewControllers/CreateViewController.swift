//
//  ViewController.swift
//  Connect
//
//  Created by Leandro Diaz on 2/4/21.
//

import UIKit
/*
class CreateViewController: UIViewController {

    var userProfile = [UserProfile]()
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.frame = view.bounds
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: CreateViewCell.reuseID)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = .systemBlue
        
        guard let tableView = tableView else { return}
        view.addSubview(tableView)
    }

}

extension CreateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateViewCell.reuseID, for: indexPath) as! CreateViewCell
        let items = userProfile[indexPath.row]
        cell.configure(with: items)
        
        
        return cell
    }
    
    
}
*/

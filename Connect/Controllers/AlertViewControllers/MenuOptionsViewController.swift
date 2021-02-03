//
//  MenuOptionsViewController.swift
//  Connect
//
//  Created by Leandro Diaz on 2/3/21.
//

import UIKit

class MenuOptionsViewController: UIViewController {

    var tableView: UITableView?
    var optionMenu = [Options]()
    var endOfSettings = [ResetSettings]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor =  UIColor(red: 0.2, green: 0.2, blue: 1, alpha: 0.2)
        
        configureTableView()
        
        let setting = Options(titleLabel: "Save", detailsLabel: "Save for later...", viewImage: UIImage(systemName: "bookmark.circle.fill"))
        let navigation = Options(titleLabel: "Hide", detailsLabel: "I don't want to see this post",viewImage: UIImage(systemName: "eye.slash.fill"))
        let DistanceUnits = Options(titleLabel: "Report", detailsLabel: "This post is offensive", viewImage: UIImage(systemName: "flag.slash.fill"))
        let notifications = Options(titleLabel: "Embed", detailsLabel: "Copy and paste this post in you Feeds...", viewImage: UIImage(systemName: "link.badge.plus"))
        let settingsArr = [setting, navigation, DistanceUnits,notifications]
        optionMenu.append(contentsOf: settingsArr)

        let reset = ResetSettings(titleLabel: "Delete Post", viewImage: UIImage(systemName: "xmark.circle.fill"))
        let resetArr = [ reset]
        endOfSettings.append(contentsOf: resetArr)
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView?.frame = view.bounds
        tableView?.register(OptionsViewCell.self, forCellReuseIdentifier: OptionsViewCell.reuseID)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = 60
        tableView?.clipsToBounds = true
        tableView?.backgroundColor = .clear
        tableView?.layer.cornerRadius = 10
        guard let tableView = tableView else { return}
        view.addSubview(tableView)
    }
}

extension MenuOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return optionMenu.count
        case 1:
            return endOfSettings.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: OptionsViewCell.reuseID, for: indexPath) as! OptionsViewCell
            let item = optionMenu[indexPath.row]
            cell.configureCell(with: item)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let item = endOfSettings[indexPath.row]
            
            cell.backgroundColor = UIColor(white: 0.4, alpha: 0.5)
            cell.imageView?.image = item.viewImage
            cell.imageView?.tintColor = .red
            cell.textLabel?.textColor = .red
            cell.textLabel?.font = UIFont.systemFont(ofSize: 24, weight: .light)
            cell.textLabel?.text = item.titleLabel
            
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

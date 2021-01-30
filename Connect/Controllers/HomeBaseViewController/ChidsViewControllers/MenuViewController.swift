//
//  MenuViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/16/21.
//

import UIKit

class MenuViewController: UIViewController {

    
    var menuCollectionView: UICollectionView?
    let menu = menuTesting
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureMenuCollectionView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.quaternaryLabel.cgColor
    }
    
    //MARK:- CONFIGURE COLLECTION VIEW
    func configureMenuCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 95, height: 50)
        layout.scrollDirection = .horizontal
        
        //MARK:- MENU COLLECTION VIEW
        menuCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        menuCollectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        menuCollectionView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 52)
        menuCollectionView?.delegate = self
        menuCollectionView?.dataSource = self
        menuCollectionView?.backgroundColor = .systemBackground
        
        
        //MARK:- MENU COLLECTION CELL
        menuCollectionView?.register(MenuViewCell.self, forCellWithReuseIdentifier: MenuViewCell.reuseID)
        
        guard let menuCollectionView = menuCollectionView else {
            return
        }
        view.addSubview(menuCollectionView)
    }
    

    
    
    
    
    
}

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            return menu.count
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let grid =  collectionView.dequeueReusableCell(withReuseIdentifier: MenuViewCell.reuseID, for: indexPath) as! MenuViewCell
            let currentMenu = menu[indexPath.item]
        
            grid.setCell(with: currentMenu)
            return grid
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//
//  ViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/14/21.
//

import UIKit
import SwiftUI

class TweetsViewController: UIViewController {
    
    var collectionView: UICollectionView?
    var test = testingData
    var tweets = tweetsData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        collectionView?.layoutIfNeeded()
    }
    
    //MARK:- NAV&ITEM BAR CONFIGURATION
    private func configureNavigationBar() {
        let titleImageView = UIImageView(image: Images.like)
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.tintColor = CustomColors.CustomGreen
        navigationItem.titleView = titleImageView
        
        let leftBtn = UIButton(type: .system)
        leftBtn.setImage(Images.like, for: .normal)
        leftBtn.tintColor = CustomColors.CustomGreen
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        let searchBtn = UIButton(type: .system)
        searchBtn.setImage(Images.search, for: .normal)
        searchBtn.tintColor = CustomColors.CustomGreen
        
        let newTweet = UIButton(type: .system)
        newTweet.setImage(Images.newTweet, for: .normal)
        newTweet.tintColor = CustomColors.CustomGreen
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: newTweet), UIBarButtonItem(customView: searchBtn)]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    //MARK:- CONFIGURE COLLECTION VIEW
    //MARK:- CONFIGURE COLLECTION VIEW
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width, height: 200)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView?.frame = view.bounds
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .systemBackground
        
        //MARK:- HEADER CELL
        collectionView?.register(HeaderViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderViewCell.reuseID)
        
        //MARK:- COLLECTION CELL & TWEET CELLS
        collectionView?.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.reuseID)
        collectionView?.register(TweetsViewCell.self, forCellWithReuseIdentifier: TweetsViewCell.reuseID)
        
        //MARK:- FOOTER CELL
        collectionView?.register(FooterViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterViewCell.reuseID)
        
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
}


//MARK:- COLLECTION VIEW DELEGATES
//MARK:- COLLECTION VIEW DELEGATES

extension TweetsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            return tweets.count
        default:
            return test.count
        }
    }
    
    //MARK:- COLLECTION CELL
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 1:
            let grid = collectionView.dequeueReusableCell(withReuseIdentifier: TweetsViewCell.reuseID, for: indexPath) as! TweetsViewCell
            let singleTweetsUser = tweets[indexPath.item]
            grid.configureCell(with: singleTweetsUser)
            return grid
        default:
            let grid = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseID, for: indexPath) as! HomeCollectionViewCell
            let singleUser = test[indexPath.item]
            grid.configureCell(with: singleUser)
            return grid
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let userVariable = test[indexPath.item]
        switch indexPath.section {
        case 1:
            let approximateWidth = view.frame.width - 20
            let size = CGSize(width: approximateWidth, height: 600)
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
            
            let estitatedFrame = NSString(string: tweets[indexPath.item].message).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: view.frame.width, height: estitatedFrame.height + 66)
        default:
            let approximateWidth = view.frame.width - 80
            let size = CGSize(width: approximateWidth, height: 600)
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
            
            let estitatedFrame = NSString(string: userVariable.bio).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: view.frame.width, height: estitatedFrame.height + 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //MARK:- HEADER CELL
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderViewCell.reuseID, for: indexPath) as! HeaderViewCell
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterViewCell.reuseID, for: indexPath) as! FooterViewCell
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return .zero
        }
        return CGSize(width: view.frame.width, height: 50)
    }
    
    //MARK:- FOOTER CELL
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            return .zero
        }
        return CGSize(width: view.frame.width, height: 64)
    }
}

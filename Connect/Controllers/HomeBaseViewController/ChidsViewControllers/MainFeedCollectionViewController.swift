//
//  MainFeedCollectionViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/17/21.
//

import UIKit

class MainFeedCollectionViewController: UIViewController {
    var collectionView: UICollectionView?
    let feed = testingData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        view.backgroundColor = .systemBackground
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.edgesForExtendedLayout = UIRectEdge.top
    }
    // MARK: UICollectionViewDataSource
    
    private func configureCollectionView() {
        //MARK:- CONFIGURE COLLECTION VIEW
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width, height: view.frame.height / 2)
        layout.scrollDirection = .vertical
        
        //MARK:- MENU COLLECTION VIEW
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.frame = view.bounds
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .systemBackground
        
        
        //MARK:- MENU COLLECTION CELL
        collectionView?.register(MainFeedViewCell.self, forCellWithReuseIdentifier: MainFeedViewCell.reuseID)
        
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
        layoutCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.layoutIfNeeded()
    }
    
    //        resizeTableView
    func layoutCollectionView() {
        collectionView?.frame = self.view.bounds;
        collectionView?.autoresizingMask = .flexibleHeight
        guard let collectionView = collectionView else { return }
        
        let contentSize: CGSize = collectionView.contentSize;
        let boundSize: CGSize = collectionView.bounds.size;
        var yOffset: CGFloat = 0;
        let xOffset: CGFloat = 0;
        
        if(contentSize.height < boundSize.height) {
            yOffset = floor((boundSize.height - contentSize.height) / 2)
        }
        collectionView.contentOffset = CGPoint(x: xOffset, y: yOffset);
    }
}

extension MainFeedCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainFeedViewCell.reuseID, for: indexPath) as! MainFeedViewCell
        //        let item = feed[indexPath.item]
        //        cell.setCell(item)
        
        return cell
    }
}


//
//  StoryViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/16/21.
//

import UIKit

class StoryViewController: UIViewController {
    var storyCollectionView: UICollectionView?
    
    let testData = testingData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStoryCollectionView()
//        view.addBottomBorderWithColor(color: .black, width: 2, alpha: 1)
//        view.addTopBorderWithColor(color: .black, width: 2, alpha: 1)
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.tertiarySystemBackground.cgColor
    }
    
    //MARK:- CONFIGURE COLLECTION VIEW
    private func configureStoryCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 95, height: 90)
        layout.scrollDirection = .horizontal
        //MARK:- STORY COLLECTION VIEW
        storyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        storyCollectionView?.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        
        storyCollectionView?.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
        storyCollectionView?.delegate = self
        storyCollectionView?.dataSource = self
        storyCollectionView?.backgroundColor = .systemBackground
        
        //MARK:- STORYCOLLECTION CELL
        storyCollectionView?.register(StoryViewCell.self, forCellWithReuseIdentifier: StoryViewCell.reuseID)
        
        guard let storyCollectionView = storyCollectionView else {
            return
        }
        view.addSubview(storyCollectionView)
    }

}


extension StoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            return testData.count
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let grid = collectionView.dequeueReusableCell(withReuseIdentifier: StoryViewCell.reuseID, for: indexPath) as! StoryViewCell
            let currentStory = testData[indexPath.item]
            grid.setCell(with: currentStory)
            return grid
        }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

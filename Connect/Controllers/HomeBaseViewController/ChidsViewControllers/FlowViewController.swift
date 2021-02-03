//
//  FlowViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/17/21.
//

import UIKit

class FlowViewController: UIViewController, PresentCommentVC {
    func showMenu(_ sender: UIButton) {
        showSettingsMenu(sender)
    }

    
    func presentViewComments() {
        self.showComments(message: "", buttonTitle: "Post")
    }
    
    
    enum Section {
        case main
    }
    
    
    
    let sections = Section.self
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, User>!
    var feeds = testingData
    
    var optionsView    = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        registerCell()
        configureDataSource()
        reloadData(with: feeds)
    }
    

    
    private func configureCollectionView() {
        let layuout = configureLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layuout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func registerCell(){
        collectionView.register(MainFeedViewCell.self, forCellWithReuseIdentifier: MainFeedViewCell.reuseID)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, User>(collectionView: collectionView) { (collectionView, indexPath, feed) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainFeedViewCell.reuseID, for: indexPath) as? MainFeedViewCell else {
                fatalError("can't deque cell")
            }
            cell.commentDelegate = self
            cell.setCell(with: feed)
            return cell
        }
    }
    
    fileprivate func reloadData(with feed: [User]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([.main])
        snapshot.appendItems(feed)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        //        section.orthogonalScrollingBehavior = .
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    
    //MARK:- CHILD VIEW CONTROLLERS
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame =  containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    private func showSettingsMenu(_ sender: UIButton) {
        print("called")
        
        let settinsVC = MenuOptionsViewController()
        
        self.add(childVC: settinsVC, to: optionsView)
        let width: CGFloat = 250
        let x = view.frame.width - width
        let y = sender.bounds.origin.y
        let size = CGRect(x: x - 10, y: y - 50, width: width, height: view.frame.width - 130)
        
       
        optionsView.frame = size
        optionsView.alpha = 0
        optionsView.backgroundColor = .clear
        optionsView.sizeToFit()
        optionsView.clipsToBounds = true
        view.bringSubviewToFront(optionsView)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.optionsView.alpha = 1
            
        } completion: { (nil) in}
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSettingsAnimation)))
        
        view.addSubview(optionsView)
    }
    
    @objc private func dismissSettingsAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.optionsView.alpha = 0
//            self.mapView.reloadInputViews()
        }
    }
    
}

extension FlowViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

extension FlowViewController {
    private func setupConstraints() {
        // MenuBtn
  
    }
}

//
//  SavedPostsViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/28/21.
//

import UIKit

class SavedPostsViewController: UIViewController, UITextFieldDelegate {
    
    enum Section {
        case main
    }
    
    let firestore = FireStoreManager.shared
    
    let sections = Section.self
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Feed>!
    var feedReference = [User]()
    var feeds = [Feed]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        registerCell()
        configureDataSource()
        reloadData(with: feeds)
        getFeedsFromServer()
        observeUserPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData(with: feeds)
    }
    
    //the one using today 8.13 for the current logged user
    func observeUserPosts() {
        firestore.observePost { [weak self](result) in
            guard let self = self else { return }

            switch result{
            case.success(let post):
                
                if post.isEmpty{
                        self.showEmptyState(with: "Nothing to show here yet, Create some posts...", in: self.view)
                }
                post.forEach{
                    self.feeds.append($0)
                    self.navigationItem.title = $0.author.name
                    print("receivedPost :", self.feeds)
                }
                DispatchQueue.main.async {
                    self.reloadData(with: self.feeds)
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
//    get feeds from everyoneElse
    func getFeedsFromServer() {
        firestore.getFeeds { (receivedFeeds) in
            print("receivedFeeds :", receivedFeeds!)
            guard let dataReceived = receivedFeeds else { return }
            print("received feeds on postVC: ", dataReceived)
            
            dataReceived.forEach{
                let receivedFeed = $0
                self.feedReference.append(receivedFeed)
            }
            DispatchQueue.main.async {
//                self.reloadData(with: self.feedReference)
            }
        }
    }
    
    
    private func configureNavigationBar() {
        //        let titleImageView = UIImageView(image: Images.like)
        //        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        //        titleImageView.contentMode = .scaleAspectFit
        //        titleImageView.tintColor = .blue
        //        navigationItem.titleView = titleImageView
        
        let newPost = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPost))
        navigationItem.rightBarButtonItem = newPost
    }
    
    @objc func addNewPost() {
        print("New post")
        let postVC = CreateNewPostViewController()
        let navController = UINavigationController(rootViewController: postVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    
    
    private func configureCollectionView() {
        let layuout = configureLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layuout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.sizeToFit()
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func registerCell(){
        collectionView.register(SavedPostViewCell.self, forCellWithReuseIdentifier: SavedPostViewCell.reuseID)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Feed>(collectionView: collectionView) { (collectionView, indexPath, feed) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedPostViewCell.reuseID, for: indexPath) as? SavedPostViewCell else {
                fatalError("can't deque cell")
            }
            
            cell.setCell(with: feed)
            return cell
        }
    }
    
    fileprivate func reloadData(with feed: [Feed]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Feed>()
    
            snapshot.appendSections([.main])
            snapshot.appendItems(feed)
            DispatchQueue.main.async {
                self.dataSource.apply(snapshot, animatingDifferences: false)
            }
//        }
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //        item.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 5, bottom: 5, trailing: 5)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.96), heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        group.interItemSpacing = .flexible(15)
        
        let section = NSCollectionLayoutSection(group: group)
        //        section.interGroupSpacing = 15
        //        section.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 5, bottom: 5, trailing: 5)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}


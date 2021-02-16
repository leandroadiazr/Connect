//
//  PostViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/17/21.
//
/*
import UIKit

class PostViewController: UIViewController, UITextFieldDelegate {
    
    enum Section: CaseIterable {
        case main
        case feeds
    }
    
    let firestore = FireStoreManager.shared
    
    let sections = Section.self
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, User>!
//    var feeds = testingFeed
    var feedReference = [User]()
    var feeds = testingData
//    var feedArray = [Feed]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        registerCell()
        configureDataSource()
//        firestore.configure()
        reloadData(with: feedReference)
//        firestore.configure()
        print("firestore data :", firestore)
        
      getFeedsFromServer()
        
    }
    
    func getFeedsFromServer() {
//        firestore.observePost { [weak self] (result) in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success(let post):
//                print("receivedFeeds :", "\(String(describing: post))")
//                
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//                //create alert showing error or show empty state
//            }
//        }
        
        
        
        
        
        
        
        
//        firestore.getFeeds { (receivedFeeds) in
//            print("receivedFeeds :", "\(String(describing: receivedFeeds))")
//            guard let dataReceived = receivedFeeds else { return }
//            print("received feeds on postVC: ", dataReceived)
//            dataReceived.forEach{
//                let receivedFeed = $0
//                self.feedReference.append(receivedFeed)
//            }
//            DispatchQueue.main.async {
//                self.reloadData(with: self.feedReference)
//            }
//
//        }
//        firestore.getFeeds { [weak self ](receivedFeeds) in
//            guard let self = self else { return }
//            guard let receivedFeeds = receivedFeeds else { return }
//            print("received feeds on postVC: ", receivedFeeds)
//            self.feedReference.append(contentsOf: receivedFeeds)
//            print(self.feedReference)
//            self.reloadData(with: self.feedReference)
//        }
//        print(feedReference)
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
        let layuout = generateLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layuout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.sizeToFit()
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layouEnviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let sectionLayoutKind = Section.allCases[sectionIndex]
            switch (sectionLayoutKind) {
            case .main:
                return self.configureProfileLayout()
            case .feeds:
                return self.configureFeedsLayout()
            }
        }
        
        return layout
    }
    
    private func registerCell() {
        collectionView.register(ProfileAreaPostViewCell.self, forCellWithReuseIdentifier: ProfileAreaPostViewCell.reuseID)
        collectionView.register(PostsFeedCell.self, forCellWithReuseIdentifier: PostsFeedCell.reuseID)
    }
    
    /*******/
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, User>(collectionView: collectionView) { (collectionView, indexPath, data) -> UICollectionViewCell? in
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType {
            //PROFILE SECTION
            case .main:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileAreaPostViewCell.reuseID, for: indexPath) as? ProfileAreaPostViewCell else {
                    fatalError("can't deque cell")
                }
                cell.setCell(with: data)
                return cell
                
                //FEEDS SECTION
            case .feeds:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostsFeedCell.reuseID, for: indexPath) as? PostsFeedCell else {
                    fatalError("can't deque cell")
                }
//                cell.backgroundColor = .red
                cell.setCell(with: data)
                return cell
            }
        }
    }
    
    fileprivate func reloadData(with feed: [User]) {
        
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        
        if feed.isEmpty {
            self.showEmptyState(with: "Nothing to show here yet, Create some posts...", in: self.view)
        } else {
        
            snapshot.appendSections([.main])
            
//            for item in feed {
//                let user: [User] = [User(profileImage: item.profileImage, name: item.name, handler: "", email: "", bio: "", location: "")]
                snapshot.appendItems(feed)
//            }

//            snapshot.appendSections([.feeds])
            
//        snapshot.appendItems(feed)
            
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
        }
    }
    
    
    //PROFILE LAYOUT
    private func configureProfileLayout()  -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

       
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.96), heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        group.interItemSpacing = .flexible(15)
       
        let section = NSCollectionLayoutSection(group: group)

        section.orthogonalScrollingBehavior = .none
//        let layout = UICollectionViewCompositionalLayout(section: section)
        return section
    }
    
    
//    SECTION LAYOUT
    private func configureFeedsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 5, bottom: 5, trailing: 5)
       
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.96), heightDimension: .fractionalHeight(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        group.interItemSpacing = .flexible(15)
       
        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 15
//        section.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 5, bottom: 5, trailing: 5)
        section.orthogonalScrollingBehavior = .groupPagingCentered
//        let layout = UICollectionViewCompositionalLayout(section: section)
        return section
    }
   
}
 

*/

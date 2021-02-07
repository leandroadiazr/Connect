//
//  DetailsViewController.swift
//  Connect
//
//  Created by Leandro Diaz on 2/3/21.
//

import UIKit

class DetailsViewController: UIViewController, DetailsAction {
    func detailsAction() {
        self.showComments(message: "", buttonTitle: "Post")
    }
    
    enum Section {
        case main
    }
    
    var detailsString: String!
    
    let firestore = FireStoreManager.shared
    
    let sections = Section.self
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Feed>!
    var feedReference = [Feed]()
    var feeds = [Feed]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed Details"
        configureNavigationBar()
        configureCollectionView()
        registerCell()
        configureDataSource()
        getFeedsFromServer(string: detailsString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
//    get details Feeds
    func getFeedsFromServer(string: String) {
        firestore.getFeeds(for: string) { (receivedFeeds) in
            guard let dataReceived = receivedFeeds else { return }
            self.feeds.append(contentsOf: dataReceived)
            DispatchQueue.main.async {
                self.reloadData(with: self.feeds)
            }
        }
    }
    
    
    private func configureNavigationBar() {
        //        let titleImageView = UIImageView(image: Images.like)
        //        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        //        titleImageView.contentMode = .scaleAspectFit
        //        titleImageView.tintColor = .blue
        //        navigationItem.titleView = titleImageView
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = cancel
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

    private func configureCollectionView() {
        let layuout = configureLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layuout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.sizeToFit()
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func registerCell(){
        collectionView.register(DetailsViewCell.self, forCellWithReuseIdentifier: DetailsViewCell.reuseID)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Feed>(collectionView: collectionView) { (collectionView, indexPath, feed) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsViewCell.reuseID, for: indexPath) as? DetailsViewCell else {
                fatalError("can't deque cell")
            }
            cell.detailsDelegate = self
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
    }
    
    private func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.85))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        group.interItemSpacing = .flexible(15)

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

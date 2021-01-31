//
//  UserProfileViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/17/21.
//

import UIKit
import FirebaseAuth
import Firebase

class UserProfileViewController: UIViewController {

    enum Section {
        case main
    }
    let logoutButton = CustomGenericButton(backgroundColor: .systemRed, title: "Logout")
    let firestore = FireStoreManager.shared
    var ref: DatabaseReference!
    var userManager = UserManager.shared
    var updateTitle     = UserManager.shared.updatedTitle
    
    let sections = Section.self
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, User>!
    var feedReference = [User]()
    var feeds = testingData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        registerCell()
        configureDataSource()
        
        reloadData(with: feedReference)
        getUserDataFromServer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        isUserLoggedIn()
        fetcUserOnLoad()
       
    }
    
    private func fetcUserOnLoad() {
        userManager.fetchUser { (result) in
            print(result)
            print("updateTitle on load :", self.updateTitle)
        }
    }
    
    
//    private func isUserLoggedIn() {
//        if Auth.auth().currentUser?.uid == nil {
//            print("No user found")
//            userManager.handleLogout()
//            showLoadingView()
//            perform(#selector(showLoginVC), with: nil, afterDelay: 0.1)
//
//        } else {
//            userManager.fetchUser { (result) in
//                print("user loaded :", result)
//
//                self.showLoadingView()
//                self.createTabBar()
//            }
//        }
//    }
    
//    private func isUserLoggedIn() {
//        if Auth.auth().currentUser?.uid == nil {
//            perform(#selector(handleLogout), with: nil, afterDelay: 0)
//
//        } else {
//            self.ref = Database.database().reference(fromURL: "https://connect-f747d-default-rtdb.firebaseio.com/")
//            let uid = Auth.auth().currentUser?.uid
//            self.ref.child("users").child(uid!).observeSingleEvent(of: .value) { [weak self ](snapShot) in
//                guard let self = self else { return }
//                if let values = snapShot.value as? [String: Any]{
//                    self.updateTitle = values["name"] as! String
//                    print(self.updateTitle)
//                    self.title = self.updateTitle
//                }
//            } withCancel: { (error) in}
//        }
//    }
    
//    private func isUserLoggedIn() {
//        if Auth.auth().currentUser?.uid == nil {
//            print("No user found")
//            userManager.handleLogout()
//            showLoadingView()
//            perform(#selector(showLoginVC), with: nil, afterDelay: 0.1)
//
//        } else {
//            userManager.fetchUser { (result) in
//                print("user loaded :", result)
//
//                self.showLoadingView()
//                self.createTabBar()
//            }
//        }
//    }
    
    @objc private func handleLogout() {
        print("Logut")
        userManager.handleLogout()
        
        showLoadingView()
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .custom
        loginVC.transitioningDelegate = self
        present(loginVC, animated: true)
    }
    
    func getUserDataFromServer() {
        firestore.getFeeds { (receivedFeeds) in
            print("receivedFeeds :", receivedFeeds)
            guard let dataReceived = receivedFeeds else { return }
            print("received feeds on postVC: ", dataReceived)
            
            dataReceived.forEach{
                let receivedFeed = $0
                self.feedReference.append(receivedFeed)
            }
            
            DispatchQueue.main.async {
                self.reloadData(with: self.feedReference)
            }
        }
    }
    
    
    private func configureNavigationBar() {
        
        
                let titleImageView = UIImageView(image: Images.like)
                titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                titleImageView.contentMode = .scaleAspectFit
                titleImageView.tintColor = .blue
                navigationItem.title = updateTitle
        
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        let newPost = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPost))
        navigationItem.rightBarButtonItem = newPost
        setupConstraints()
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
        collectionView.register(UserProfileViewCell.self, forCellWithReuseIdentifier: UserProfileViewCell.reuseID)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, User>(collectionView: collectionView) { (collectionView, indexPath, feed) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileViewCell.reuseID, for: indexPath) as? UserProfileViewCell else {
                fatalError("can't deque cell")
            }
            
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
        //        item.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 5, bottom: 5, trailing: 5)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.96), heightDimension: .fractionalHeight(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        group.interItemSpacing = .flexible(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}

extension UserProfileViewController {
    private func setupConstraints() {

        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 25),
            logoutButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}

extension UserProfileViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let customTransition = CustomTransition()
        customTransition.isPresenting = true
        return customTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let customTransition = CustomTransition()
        customTransition.isPresenting = false
        return customTransition
    }
}

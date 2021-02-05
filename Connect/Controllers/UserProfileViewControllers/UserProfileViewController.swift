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
    let logoutButton    = CustomGenericButton(backgroundColor: .systemRed, title: "Logout")
    let firestore       = FireStoreManager.shared
    var ref             : DatabaseReference!
    var userManager     = UserManager.shared
    
    let sections        = Section.self
    var collectionView  : UICollectionView!
    var dataSource      : UICollectionViewDiffableDataSource<Section, UserProfile>!
    var feeds           = testingData
    var loggedUser      = [User]()
    var currentLoggedUser = [UserProfile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserProfile()
        configureNavigationBar()
        configureCollectionView()
        registerCell()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func fetchUserProfile() {
        
        
        
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        print(userID)
        userManager.getCurrentUser(userID: userID) { (user) in
            print(user!)
            if let user = user {
                print(user)
//                for field in user {
                    self.title = user.name
//                }
                self.currentLoggedUser.append(user)
                print(self.currentLoggedUser)
                DispatchQueue.main.async {
                    self.reloadData(with: self.currentLoggedUser)
                }
            }
        }
    }
    
    @objc private func handleLogout() {
        print("Logut")
        userManager.handleLogout()
        showLoadingView()
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .custom
        loginVC.transitioningDelegate = self
        present(loginVC, animated: true)
    }

    
    private func configureNavigationBar() {
        let titleImageView = UIImageView(image: Images.like)
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.tintColor = .blue
        //        navigationItem.title = updateTitle
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
        collectionView.isScrollEnabled = false
        view.addSubview(collectionView)
    }
    
    private func registerCell(){
        collectionView.register(UserProfileViewCell.self, forCellWithReuseIdentifier: UserProfileViewCell.reuseID)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UserProfile>(collectionView: collectionView) { (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileViewCell.reuseID, for: indexPath) as? UserProfileViewCell else {
                fatalError("can't deque cell")
            }
            cell.setCell(with: user)
            return cell
        }
    }
    
    fileprivate func reloadData(with feed: [UserProfile]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserProfile>()
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

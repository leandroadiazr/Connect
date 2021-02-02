//
//  BaseViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/16/21.
//

import UIKit
import Firebase
import FirebaseAuth


class HomeBaseViewController: UIViewController {
    
    var storyView       = UIView()
    var menuView        = UIView()
    var mainFeedView    = UIView()
    var ref: DatabaseReference!
    var updateTitle     = ""
    
    //    let storyVC = StoryViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CustomColors.CustomGreen
        configureChildViewControllers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//                dismissLoadingView()
      
        isUserLoggedIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        dismissLoadingView()
        configureNavigationBar()
    }
    
    
    private func isUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        } else {
            self.ref = Database.database().reference(fromURL: "https://connect-f747d-default-rtdb.firebaseio.com/") 
            let uid = Auth.auth().currentUser?.uid
            self.ref.child("users").child(uid!).observeSingleEvent(of: .value) { [weak self ](snapShot) in
                guard let self = self else { return }
                if let values = snapShot.value as? [String: Any]{
                    self.updateTitle = values["name"] as! String
                    print(self.updateTitle)
                }
            } withCancel: { (error) in
               
            }
        }
    }
    
    @objc private func handleLogout() {
        print("Logut")
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
        
        let logingVC = LoginViewController()
        present(logingVC, animated: true, completion: nil)
    }
    
    private func configureNavigationBar() {
        let titleImageView = UIImageView(image: Images.like)
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.tintColor = .blue
//        navigationItem.titleView = titleImageView
        navigationItem.title = updateTitle
        
        let newPost = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPost))
        navigationItem.rightBarButtonItem = newPost
    }
    
    @objc func addNewPost() {
        print("New post")
        let postVC = CreateNewPostViewController()
        let navController = UINavigationController(rootViewController: postVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame =  containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    //MARK:- CONFIGURE COLLECTION VIEW
    func configureChildViewControllers() {
        
        self.edgesForExtendedLayout = UIRectEdge.top
        let menuViewController      = MenuViewController()
        let storyViewController     = StoryViewController()
        let mainFeedViewController  = FlowViewController()
        
        self.add(childVC: storyViewController, to: storyView)
        self.add(childVC: menuViewController, to: menuView)
        self.add(childVC: mainFeedViewController, to: mainFeedView)
        storyView.translatesAutoresizingMaskIntoConstraints     = false
        menuView.translatesAutoresizingMaskIntoConstraints      = false
        mainFeedView.translatesAutoresizingMaskIntoConstraints  = false
        mainFeedViewController.edgesForExtendedLayout = UIRectEdge.all
        view.addSubview(storyView)
        view.addSubview(menuView)
        view.addSubview(mainFeedView)
        setupConstraints()
    }
    
    
}


extension HomeBaseViewController {
    
    func setupConstraints() {
//        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            storyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3),
            storyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storyView.heightAnchor.constraint(equalToConstant: 100),
            
            menuView.topAnchor.constraint(equalTo: storyView.bottomAnchor, constant: 3),
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuView.heightAnchor.constraint(equalToConstant: 52),
            
            mainFeedView.topAnchor.constraint(equalTo: menuView.bottomAnchor, constant: 3),
            mainFeedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainFeedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainFeedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
}

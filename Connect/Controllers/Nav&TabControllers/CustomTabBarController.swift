//
//  CustomTabBarController.swift
//  Content
//
//  Created by Leandro Diaz on 1/14/21.
//

import UIKit
import AuthenticationServices
import Firebase
import FirebaseAuth

class CustomTabBarController: UITabBarController {
    var ref: DatabaseReference!
    var updateTitle     = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.showLoadingView()
            createTabBar()
        }
    }
    

    
    @objc private func handleLogout() {
        print("Logut")
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
        showLoadingView()
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .custom
        loginVC.transitioningDelegate = self
        present(loginVC, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.showLoadingView()
        isUserLoggedIn()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.dismissLoadingView()
        self.title = updateTitle
    }
    
    
    
    fileprivate func createTabBar() {
        UITabBar.appearance().tintColor = CustomColors.CustomGreenBright
        UITabBar.setTransparency()
        self.viewControllers = [createHomeBaseViewController(), createTweetsViewController(), createPostViewController(), createDiscussionViewController(), createProfileViewController()]
    }
    
    func createHomeBaseViewController() -> UINavigationController {
        let baseCon             = HomeBaseViewController()
        baseCon.tabBarItem = UITabBarItem(title: "", image: Images.home, selectedImage: Images.homeFill)
        tabBarItem.tag = 0
        let navCon = CustomNavCon(rootViewController: baseCon, tintColor: .systemBackground, translucent: false,
                                  largeTitles: false, title: updateTitle)
        return navCon
    }
    
    func createTweetsViewController() -> UIViewController {
        let tweetsNavCon        = TweetsViewController()
        tweetsNavCon.tabBarItem = UITabBarItem(title: "", image: Images.feeds, selectedImage: Images.feedsFill)
        tabBarItem.tag = 1
        let navCon = CustomNavCon(rootViewController: tweetsNavCon, tintColor: .systemBackground, translucent: false,
                                  largeTitles: false, title: "")
        return navCon
    }
    
    func createPostViewController() -> UINavigationController {
        let postNavCon        = SavedPostsViewController()
        postNavCon.tabBarItem = UITabBarItem(title: "", image: Images.post?.applyingSymbolConfiguration(.init(pointSize: 45))?.withTintColor(.green, renderingMode: .automatic), selectedImage: Images.postFill?.applyingSymbolConfiguration(.init(pointSize: 45)))
        tabBarItem.tag = 2
        let navCon = CustomNavCon(rootViewController: postNavCon, tintColor: .systemBackground, translucent: false,
                                  largeTitles: false, title: "")
        
        return navCon
    }
    
    func createDiscussionViewController() -> UINavigationController {
        let discussionCon             = DiscussionViewController()
        
        discussionCon.tabBarItem = UITabBarItem(title: "", image: Images.discussion, selectedImage: Images.discusFill )
        tabBarItem.tag = 3
        let navCon = CustomNavCon(rootViewController: discussionCon, tintColor: .systemBackground, translucent: false,
                                  largeTitles: false, title: "")
        return navCon
    }
    
    func createProfileViewController() -> UIViewController {
        let homeNavCon        = UserProfileViewController()
        homeNavCon.tabBarItem = UITabBarItem(title: "", image: Images.userArea, selectedImage: Images.userAreaFill )
        tabBarItem.tag = 4
        let navCon = CustomNavCon(rootViewController: homeNavCon, tintColor: .systemBackground, translucent: false,
                                  largeTitles: false, title: "")
        return navCon
    }
}

extension CustomTabBarController: UIViewControllerTransitioningDelegate {
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

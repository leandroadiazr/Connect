//
//  CustomTabBarController.swift
//  Content
//
//  Created by Leandro Diaz on 1/14/21.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    var updateTitle     = UserManager.shared.updatedTitle
    var userProfile     : UserProfile?
    private let Green   = CustomColors.CustomGreenBright
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.showLoadingView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = updateTitle
//        self.dismissLoadingView()
    }

    @objc private func showLoginVC() {
        showLoginViewController()
    }
    
    fileprivate func createTabBar() {
        UITabBar.appearance().tintColor = Green
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
        let postNavCon        = DummyViewController()
        postNavCon.tabBarItem = UITabBarItem(title: "", image: Images.post?.applyingSymbolConfiguration(.init(pointSize: 45))?.withTintColor(.green, renderingMode: .automatic), selectedImage: Images.postFill?.applyingSymbolConfiguration(.init(pointSize: 45)))
        tabBarItem.tag = 2
        let navCon = CustomNavCon(rootViewController: postNavCon, tintColor: .systemBackground, translucent: false,
                                  largeTitles: false, title: "")
        self.delegate = self
        return navCon
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            let postNavCon = CreateNewPostViewController()
            let navCon = UINavigationController(rootViewController: postNavCon)
            self.present(navCon, animated: true, completion: nil)
        }
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


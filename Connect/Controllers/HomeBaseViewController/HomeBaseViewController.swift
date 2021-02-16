//
//  BaseViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/16/21.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreLocation

class HomeBaseViewController: UIViewController, CLLocationManagerDelegate {
    
    var storyView       = UIView()
    var menuView        = UIView()
    var mainFeedView    = UIView()
    var ref: DatabaseReference!
    var usersManager    = UserManager.shared
    var updateTitle     = ""
    let locationManager = CLLocationManager()
    var userLocation: String?
    
    let usernameLabel = CustomTitleLabel(title: "", textAlignment: .center, fontSize: 18)
    let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        view.backgroundColor = CustomColors.CustomGreen
        configureChildViewControllers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("dismissCAlled on homebased")
        //        self.dismissLoadingView()
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
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        
        guard let currentUser = usersManager.currentUserProfile else { return }
        let profileView = CustomProfileView(frame: .zero, profilePic: currentUser.profileImage, userName: currentUser.name)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(profileView)
        profileView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant:  -50).isActive = true
        self.navigationItem.titleView = containerView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locationManager.location else { return }
        let coordinates = CLGeocoder()
        coordinates.reverseGeocodeLocation(location) { (address, error) in
            if let placemark = address?.first {
                self.userLocation = placemark.locality
            }
        }
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

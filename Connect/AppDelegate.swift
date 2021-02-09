//
//  AppDelegate.swift
//  Connect
//
//  Created by Leandro Diaz on 1/29/21.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        //        localFirebaseAuthentication()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        return true
    }
    
    private func localFirebaseAuthentication() {
        //        FirebaseApp.configure()
        
        let settings = Firestore.firestore().settings
        settings.host = "localhost:4000"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        
    }
    
    private func configureFireStore() {
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) ->Bool {
        
        ApplicationDelegate.shared.application(app,open: url,sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let unwrappedError = error {
            print("Failed to sign in with google: ", unwrappedError.localizedDescription)
            return
        }
        
        let userManager = UserManager.shared
        //        print(user.profile.email)
        //        let userID = Auth.auth().currentUser?.uid
        guard let email = user.profile.email,
              let name = user.profile.name,
              let imageURL = user.profile.imageURL(withDimension: 70) else { return }
        
        guard let authentication = user.authentication else {
            print("missing auth object of google")
            return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) {  (authResult, error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
                return }
            guard let result = authResult else { return }
            print("logged in with Google", result)
            let userID = result.user.uid
            print(userID)
            userManager.globalSignInWith(userID: userID, email: email, name: name, imageURL: imageURL.absoluteString)
            NotificationCenter.default.post(name: .didLoginNotification, object: nil)
            
        }
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google has sign out")
    }
    
    
    
}


//@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        FirebaseApp.configure()
//
//        return true
//    }
//
//
//
//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//
//
//}



//        FlagFetcher.fetchFlags { result in
//            if case let .success(flags) = result,
//               flags.contains("use_facebook") {
//                // Initialize the SDK
//                ApplicationDelegate.shared.application(
//                    application,
//                    didFinishLaunchingWithOptions: launchOptions
//                )
//            }
//        }
//
//        class AppDelegate: UIResponder, UIApplicationDelegate {
//
//            func application(
//                _ application: UIApplication,
//                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//            ) -> Bool {
//
//                ApplicationDelegate.shared.application(
//                    application,
//                    didFinishLaunchingWithOptions: launchOptions
//                )
//
//                return true
//            }
//
//            func application(
//                _ app: UIApplication,
//                open url: URL,
//                options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//            ) -> Bool {
//
//                ApplicationDelegate.shared.application(
//                    app,
//                    open: url,
//                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                    annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//                )
//
//            }
//
//        }
//

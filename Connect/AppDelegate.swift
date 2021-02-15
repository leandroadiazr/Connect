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
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var persistenceManager = PersistenceManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        //        localFirebaseAuthentication()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = -150
        
        return true
    }
    
    private func localFirebaseAuthentication() {
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
            userManager.globalSignInWith(userID: userID, email: email, name: name, imageURL: imageURL.absoluteString)
            NotificationCenter.default.post(name: .didLoginNotification, object: nil)
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google has sign out")
    }
}

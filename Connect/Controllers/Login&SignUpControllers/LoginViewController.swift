//
//  LoginViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/29/21.
//

import UIKit
import AuthenticationServices
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import IQKeyboardManagerSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    //MARK:- NOTIFICATION CENTER PROPERTIES
    private var loginObserver: NSObjectProtocol?
    
    //MARK:- UI ELELMENTS
    //MARK:- IMAGES
    let topBackgroundImage      = UIImageView()
    let bottomBackgroundImage   = UIImageView()
    let bubbleImageView         = UIImageView()
    let starsImage              = UIImageView()
    
    //MARK:- TextFields and Labels
    let titleLabel = CustomTitleLabel(title: "Welcome", textAlignment: .center, fontSize: 28)
    
    let emailLabel = CustomSecondaryTitleLabel(title: "EMAIL ADDRESS", fontSize: 16, textColor: .lightText)
    let emailTextField = CustomTextField(textAlignment: .left, fontSize: 16, placeholder: "   EnterYourEmail")
    let emailLine   = UIView()
    
    let passwordLabel = CustomSecondaryTitleLabel(title: "PASSWORD", fontSize: 16, textColor: .lightText)
    let passwordTextField = CustomTextField(textAlignment: .left, fontSize: 16, placeholder: "  ******")
    let passwordLine   = UIView()
    
    let firstTimeLabel = CustomSecondaryTitleLabel(title: "Firs time Connecting...? ", fontSize: 16, textColor: .lightText)
    let inputErrorLabel = CustomSecondaryTitleLabel(title: "Something went wrong...", fontSize: 13, textColor: .systemRed)
    
    //MARK:- Buttons
    let forgotPasswordBtn = CustomGenericButton(backgroundColor: .systemRed, title: "Forgot Password?")
    let goToSignUpBtn =  CustomGenericButton(backgroundColor: .clear, title: "Click here to Sign Up")
    let signInWEmailBtn =  CustomMainButton(backgroundColor: .clear, title: "Sign In", textColor: .white, borderWidth: 0.3, borderColor: CustomColors.CustomGreen.cgColor, buttonImage: nil)
    var appleIDBtn = ASAuthorizationAppleIDButton()
    let FBloginButton = FBLoginButton()
    let GgLoginButton = GIDSignInButton()
    
    var isEmailEntered: Bool { return !emailTextField.text!.isEmpty }
    var isPassEntered: Bool { return !passwordTextField.text!.isEmpty }
    var ref: DatabaseReference!
    var userManager = UserManager.shared
    var persistenceManager = PersistenceManager.shared
    var localUser: UserProfile?
    var userCached : [String: Any] = [:]
    let userProfile = [UserProfile]()
    
    //MARK:- LIFECYCLE EVENTS
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNofitications()
        configure()
        dismissKeyboard()
        
    }
    
    private func setupNofitications() {
        loginObserver = NotificationCenter.default.addObserver(forName: .didLoginNotification, object: nil, queue: .main)  {[weak self] _ in
            guard self != nil else { return }
        }
    }
    
    deinit {
        if loginObserver != nil {
            NotificationCenter.default.removeObserver(loginObserver as Any)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputErrorLabel.isHidden = true
        forgotPasswordBtn.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    //MARK:- UI ELEMENTS
    //MARK:- CONFIGURE UI ELEMENTS
    private func configure() {
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        configureBackgroundImages()
        configureLabels()
        configureButtons()
        LoginSetupConstraints()
    }
    
    //MARK:- UI ELEMENTS
    //MARK:- LABELS & TEXT FIELDS
    private func configureLabels() {
        //Labels & TextFields
        let textFields = [emailTextField, passwordTextField ]
        for field in textFields {
            field.translatesAutoresizingMaskIntoConstraints = false
            field.layer.borderWidth = 0
            field.backgroundColor = .clear
            
            field.textColor = .secondaryLabel
            field.returnKeyType = .go
            field.clearButtonMode = .whileEditing
            field.addTarget(self, action: #selector(textFieldAction), for: .primaryActionTriggered)
            view.addSubview(field)
        }
        emailTextField.delegate = self
        emailTextField.becomeFirstResponder()
        passwordTextField.delegate = self
        
        let labels = [titleLabel, emailLabel, passwordLabel, firstTimeLabel, inputErrorLabel]
        for label in labels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .secondaryLabel
            view.addSubview(label)
        }
        titleLabel.textColor = CustomColors.CustomBlue
        inputErrorLabel.textColor = UIColor.systemRed
        
        let lines = [emailLine, passwordLine]
        for line in lines {
            line.backgroundColor = CustomColors.CustomGreenLightBright.withAlphaComponent(0.8)
            line.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(line)
        }
    }
    
    //MARK:- BUTTONS
    private func configureButtons() {
        //FORGOT BTN
        let buttons = [forgotPasswordBtn, signInWEmailBtn, goToSignUpBtn, appleIDBtn, FBloginButton, GgLoginButton ]
        for button in buttons {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            view.addSubview(button)
        }
        goToSignUpBtn.setTitleColor(.link, for: .normal)
        
        //FORGOT BTN
        forgotPasswordBtn.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        forgotPasswordBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        //SIGNUP BTN
        goToSignUpBtn.addTarget(self, action: #selector(goingTosignUpAction), for: .touchUpInside)
        goToSignUpBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        //SIGNIN WITH EMAIL BTN
        signInWEmailBtn.addTarget(self, action: #selector(signInWithEmail), for: .touchUpInside)
        signInWEmailBtn.setBackgroundImage(Images.buttonActive, for: .normal)
        
        //SIGNIN APPLE BTN
        appleIDBtn.addTarget(self, action: #selector(signinWithAppleID), for: .touchUpInside)
        
        //SIGNIN WITH FACEBOOK BTN
        facebookToken()
        
        //SIGNIN WITH GOOGLE BTN
        googleSetupToken()
    }
    
    private func facebookToken() {
        FBloginButton.delegate = self
        FBloginButton.permissions = ["email", "public_profile"]
        
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
    }
    
    private func googleSetupToken() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    
    //MARK:- BACKGROUND IMAGES
    private func configureBackgroundImages() {
        //Background top Image
        topBackgroundImage.image = Images.topBackground
        topBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundImage)
        
        //Bubble BG Image
        bubbleImageView.image = Images.bubbleImage
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageView.backgroundColor = UIColor.clear
        bubbleImageView.tintColor = CustomColors.CustomGreenLightBright.withAlphaComponent(0.8)
        bubbleImageView.applyCustomShadow()
        view.addSubview(bubbleImageView)
        
        //Stars
        starsImage.image = Images.startsYellow
        starsImage.translatesAutoresizingMaskIntoConstraints = false
        view.bringSubviewToFront(starsImage)
        view.addSubview(starsImage)
        
        //Background Bottom Image
        bottomBackgroundImage.image = Images.botBackground
        bottomBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBackgroundImage)
    }
    
    //MARK:- TEXT FIELDS ACTIONS
    @objc private func textFieldAction(_ textField: UITextField) {
        print("typed")
        textField.resignFirstResponder()
        signInWithEmail()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFields = [emailTextField, passwordTextField]
        if textField == textFields[0] {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signInWithEmail()
        }
        return true
    }
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
        let textFields = [emailTextField, passwordTextField]
        for field in textFields {
            field.resignFirstResponder()
        }
    }
    
    //MARK:- BUTTON ACTIONS
    //MARK:- FORGOT PASSWORD
    @objc private func forgotPassword() {
        print("forgotPassword")
        inputErrorLabel.isHidden = false
        forgotPasswordBtn.isHidden = false
    }
    
    //MARK:- TRASITIONS
    //MARK:- SIGN UP
    @objc private func goingTosignUpAction() {
        print("going to signup")
        let signupVC = SignUpViewController()
        signupVC.modalPresentationStyle = .custom
        signupVC.transitioningDelegate = self
        present(signupVC, animated: true)
    }
    
    //MARK:- SIGNIN WITH EMAIL
    @objc private func signInWithEmail() {
        print("signInWithEmail")
        guard isEmailEntered || isPassEntered else {
            showAlert(title: "Empty Fields", message: "Please check your Email and Password...!", buttonTitle: "Ok")
            forgotPassword()
            return
        }
        
        if let email = emailTextField.text,
           let passOne = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: passOne) { (user, error) in
                if let unwrappedError = error {
                    self.showAlert(title: "Something is wrong...", message: "\(unwrappedError.localizedDescription)", buttonTitle: "Return")
                    self.forgotPassword()
                    print(unwrappedError.localizedDescription)
                    return
                }
                self.continueAfterLogin()
            }
        }
    }
    
    //MARK:- ON LOGGED IN SUSCESS
    private func continueAfterLogin() {
        
        self.navigationController?.popViewController(animated: true)
        DispatchQueue.main.async {
            let mainVC = CustomTabBarController()
            mainVC.modalPresentationStyle = .overFullScreen
            self.present(mainVC, animated: true, completion: nil)
        }
    }
    
    //MARK:- SIGN IN WITH APPLE ID
    @objc func signinWithAppleID() {
        let provider    = ASAuthorizationAppleIDProvider()
        let request     = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        //AuthController
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    //MARK:- SIGN IN WITH GOOGLE
    @objc private func signInWithGoogle() {
        print("signInWithGoogle")
        GIDSignIn.sharedInstance()?.signIn()
    }
}

//MARK:- EXTENSIONS
//MARK:- EXTENSIONS LOGIN WITH APPLE ID
extension LoginViewController:  ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

//MARK:- EXTENSIONS LOGIN WITH FACEBOOK
extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("Failed to login with facebook")
            return
        }
        
        self.FBloginButton.permissions = ["public_profile","email","picture"]
        //Firebase credentials
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            guard let self = self else { return }
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
                return
            }
            
            let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name, picture"], tokenString: token, version: nil, httpMethod: .get)
            facebookRequest.start { (_, result, error) in
                if let unwrappedError = error {
                    print("Failed to login with facebook", unwrappedError.localizedDescription)
                    return
                }
                
                guard let result = result as? [String: Any] else {return}
                guard let name = result["name"] as? String,
                      let email = result["email"] as? String,
                      let picDict = result["picture"] as? [String: Any],
                      let picData = picDict["data"] as? [String: Any],
                      let imageURL = picData["url"] as? String else { print("failed to get name and email in the fb login")
                    return
                }
                guard let uuid = Auth.auth().currentUser?.uid else { return }
                print(name, email, imageURL, uuid)
                self.userManager.globalSignInWith(userID: uuid, email: email, name: name, imageURL: imageURL)
            }
            
            self.continueAfterLogin()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logged out from FB")
    }
}

extension LoginViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        if (event.touches(for: self.view) != nil) {
            return true
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is GIDSignInButton {
            return false
        }
        return true
    }
}

//MARK:- CUSTOM STORYBOARD ANIMATED TRANSITION
extension LoginViewController: UIViewControllerTransitioningDelegate {
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


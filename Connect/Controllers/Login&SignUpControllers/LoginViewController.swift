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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- UI ELELMENTS
    //MARK:- IMAGES
    let topBackgroundImage = UIImageView()
    let bottomBackgroundImage = UIImageView()
    let bubbleImageView = UIImageView()
    let starsImage      = UIImageView()
    
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
    let goToSignUpBtn =  CustomGenericButton(backgroundColor: .link, title: "Sign Up")
    let signInWEmailBtn =  CustomMainButton(backgroundColor: .clear, title: "Sign In", textColor: .white, borderWidth: 0.3, borderColor: CustomColors.CustomGreen.cgColor, buttonImage: nil)
    var appleIDBtn = ASAuthorizationAppleIDButton()
    let facebookBtn = CustomGenericButton()
    let googleBtn =  CustomGenericButton()
    
    var isEmailEntered: Bool { return !emailTextField.text!.isEmpty }
    var isPassEntered: Bool { return !passwordTextField.text!.isEmpty }
    var ref: DatabaseReference!
    var userManager = UserManager.shared
    var localUser: UserProfile?
    let userProfile = [UserProfile]()
    
    //MARK:- LIFECYCLE EVENTS
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        dismissKeyboard()
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
    
    //MARK:- LOGIN & LOGOUT FUNCTIONALITY
    
//    @objc private func handleLogout() {
//        print("Logut")
//        do {
//            try Auth.auth().signOut()
//        } catch let logoutError {
//            print(logoutError.localizedDescription)
//        }
//        backTosignInAction()
//    }
    
    //MARK:- UI ELEMENTS
    //MARK:- CONFIGURE UI ELEMENTS
    private func configure() {
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
        let buttons = [forgotPasswordBtn, signInWEmailBtn, goToSignUpBtn, appleIDBtn, facebookBtn, googleBtn ]
        for button in buttons {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            view.addSubview(button)
        }
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
        facebookBtn.addTarget(self, action: #selector(signInWithFacebook), for: .touchUpInside)
        facebookBtn.setBackgroundImage(Images.loginWithFB, for: .normal)
        
        //SIGNIN WITH GOOGLE BTN
        googleBtn.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
        googleBtn.setBackgroundImage(Images.loginWGoogle, for: .normal)
        
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
        if textField == textFields[1] {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    @objc private func dismissKeyboard() {
        emailTextField.resignFirstResponder()
    }
    
    
    
    //MARK:- BUTTON ACTIONS
    
    //MARK:- FORGOT PASSWORD
    @objc private func forgotPassword() {
        print("forgotPassword")
        inputErrorLabel.isHidden = false
        forgotPasswordBtn.isHidden = false
    }
    
    //MARK:- TRASITIONS
    //MARK:- SIGN In
    @objc private func backTosignInAction() {
        print("going to signup")
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .custom
        loginVC.transitioningDelegate = self
        present(loginVC, animated: true)
    }
    
    //MARK:- SIGN UP
    @objc private func goingTosignUpAction() {
        print("going to signup")
        let signupVC = SignUpViewController()
        signupVC.modalPresentationStyle = .custom
        signupVC.transitioningDelegate = self
        present(signupVC, animated: true)
    }
    
    
    
    private func transitionToHomeVC() {
        let mainVC = CustomTabBarController()
        mainVC.modalPresentationStyle = .custom
        mainVC.transitioningDelegate = self
        present(mainVC, animated: true, completion: nil)
        //        self.showLoadingView()
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
//                guard let self = self else { return }
                if let unwrappedError = error {
                    self.showAlert(title: "Something is wrong...", message: "\(unwrappedError.localizedDescription)", buttonTitle: "Return")
                    self.forgotPassword()
                    print(unwrappedError.localizedDescription)
                    return
                }
                
              
                
               
                print(Auth.auth().currentUser?.uid)
//                self.userManager.setCurrentProfile()
                
                let mainVC = CustomTabBarController()
                mainVC.modalPresentationStyle = .overFullScreen
                self.present(mainVC, animated: true, completion: nil) 
            }
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
    
    //MARK:- SIGN IN WITH FACEBOOK
    @objc private func signInWithFacebook() {
        print("signInWithFacebook")
    }
    
    //MARK:- SIGN IN WITH GOOGLE
    @objc private func signInWithGoogle() {
        print("signInWithGoogle")
    }
    
}


//MARK:- EXTENSIONS
//MARK:- EXTENSIONS
extension LoginViewController:  ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
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



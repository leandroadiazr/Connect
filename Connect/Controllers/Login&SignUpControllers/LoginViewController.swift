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
    let signUpBtn =  CustomGenericButton(backgroundColor: .link, title: "Sign Up")
    let signInWEmailBtn =  CustomMainButton(backgroundColor: .clear, title: "Sign In", textColor: .white, borderWidth: 0.3, borderColor: CustomColors.CustomGreen.cgColor, buttonImage: nil)
    var appleIDBtn = ASAuthorizationAppleIDButton()
    let facebookBtn = CustomGenericButton()
    let googleBtn =  CustomGenericButton()
    
    var isEmailEntered: Bool { return !emailTextField.text!.isEmpty }
    var isPassEntered: Bool { return !passwordTextField.text!.isEmpty }
    var ref: DatabaseReference!
    
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
//        showLoadingView()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        dismissLoadingView()
    }
    
    //MARK:- LOGIN & LOGOUT FUNCTIONALITY
    
    @objc private func handleLogout() {
        print("Logut")
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
        backTosignInAction()
    }
    
    //MARK:- UI ELEMENTS
    //MARK:- CONFIGURE UI ELEMENTS
    private func configure() {
        configureBackgroundImages()
        configureLabels()
        configureButtons()
        setupConstraints()
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
        let buttons = [forgotPasswordBtn, signInWEmailBtn, signUpBtn, appleIDBtn, facebookBtn, googleBtn ]
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
        signUpBtn.addTarget(self, action: #selector(goingTosignUpAction), for: .touchUpInside)
        signUpBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        
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
            Auth.auth().signIn(withEmail: email, password: passOne) { [weak self] (user, error) in
                guard let self = self else { return }
                if let unwrappedError = error {
                    self.showAlert(title: "Something is wrong...", message: "\(unwrappedError.localizedDescription)", buttonTitle: "Return")
                    self.forgotPassword()
                    print(unwrappedError.localizedDescription)
                    return
                }
                let mainVC = CustomTabBarController()
                mainVC.modalPresentationStyle = .overFullScreen
                self.present(mainVC, animated: true, completion: nil)
//                self.showLoadingView()
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

extension LoginViewController {
    //move this to an extenxion
    private func setupConstraints() {
        let padding: CGFloat = 20
        let textPadding:CGFloat = 8
        let textWidth: CGFloat = view.frame.width / 1.7
        let customHeight: CGFloat = 45
        let topHalf: CGFloat = view.frame.height / 6.7
        let awayFromBorders: CGFloat = 100
        //  MARK: -TOP BACKGROUND IMAGE
        NSLayoutConstraint.activate([
            topBackgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topBackgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            topBackgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            topBackgroundImage.heightAnchor.constraint(equalToConstant: 240)
        ])
        
        //  MARK: -BUBBLE IMAGE
        NSLayoutConstraint.activate([
            bubbleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bubbleImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:  topHalf),
            bubbleImageView.widthAnchor.constraint(equalToConstant: 95),
            bubbleImageView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        
        //  MARK: -STARS IMAGE
        NSLayoutConstraint.activate([
            starsImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starsImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:  topHalf),
            starsImage.widthAnchor.constraint(equalToConstant: 195),
            starsImage.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        //  MARK: -BOTTOME BACKGROUND IMAGE
        NSLayoutConstraint.activate([
            bottomBackgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bottomBackgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomBackgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomBackgroundImage.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        
        //        MARK:- MAIN TITLE
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: bubbleImageView.bottomAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
        ])
        
        //        MARK:- EMAIL TITLE & TEXTFIELD
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding * 1.7),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 2),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        NSLayoutConstraint.activate([
            emailLine.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            emailLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            emailLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        //        MARK:- PASSWORD TITLE & TEXTFIELD
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
        ])
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 2),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordTextField.widthAnchor.constraint(equalToConstant: textWidth),
            passwordTextField.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        NSLayoutConstraint.activate([
            passwordLine.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            passwordLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            passwordLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        //        MARK:- MESSAGE AND ERROR LABELS
        NSLayoutConstraint.activate([
            firstTimeLabel.topAnchor.constraint(equalTo: passwordLine.bottomAnchor, constant: textPadding),
            firstTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            firstTimeLabel.widthAnchor.constraint(equalToConstant: textWidth)
        ])
        NSLayoutConstraint.activate([
            inputErrorLabel.topAnchor.constraint(equalTo: firstTimeLabel.bottomAnchor, constant: textPadding + 2),
            inputErrorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        //        MARK:- BUTTONS
        //        MARK:- BUTTONS
        NSLayoutConstraint.activate([
            forgotPasswordBtn.bottomAnchor.constraint(equalTo: passwordLine.topAnchor, constant: -textPadding),
            forgotPasswordBtn.leadingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 2),
            forgotPasswordBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
        NSLayoutConstraint.activate([
            signUpBtn.topAnchor.constraint(equalTo: passwordLine.bottomAnchor, constant: textPadding),
            signUpBtn.leadingAnchor.constraint(equalTo: firstTimeLabel.trailingAnchor, constant: 2),
            signUpBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            signUpBtn.heightAnchor.constraint(equalToConstant: 25)
            
        ])
        
        //SIGNWITH EMAIL
        NSLayoutConstraint.activate([
            signInWEmailBtn.bottomAnchor.constraint(equalTo: appleIDBtn.topAnchor, constant: -textPadding),
            signInWEmailBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInWEmailBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: awayFromBorders),
            signInWEmailBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -awayFromBorders),
            signInWEmailBtn.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        
        //SIGNWITH APPLE ID
        NSLayoutConstraint.activate([
            appleIDBtn.bottomAnchor.constraint(equalTo: facebookBtn.topAnchor, constant: -textPadding),
            appleIDBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleIDBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: awayFromBorders),
            appleIDBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -awayFromBorders),
            appleIDBtn.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        //SIGNWITH FACEBOOK
        NSLayoutConstraint.activate([
            facebookBtn.bottomAnchor.constraint(equalTo: googleBtn.topAnchor, constant: -textPadding),
            facebookBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            facebookBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: awayFromBorders),
            facebookBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -awayFromBorders),
            facebookBtn.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        //SIGNWITH GOOGLE
        NSLayoutConstraint.activate([
            googleBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding * 1.5),
            googleBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: awayFromBorders),
            googleBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -awayFromBorders),
            googleBtn.heightAnchor.constraint(equalToConstant: customHeight)
        ])
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



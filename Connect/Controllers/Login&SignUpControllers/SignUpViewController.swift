//
//  SignUpViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/29/21.
//

import UIKit
import AuthenticationServices
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- UI ELELMENTS
    //MARK:- IMAGES
    let topBackgroundImage = UIImageView()
    let bottomBackgroundImage = UIImageView()
    let bubbleImageView = UIImageView()
    let starsImage      = UIImageView()

    
    //MARK:- TextFields and Labels
    let titleLabel = CustomTitleLabel(title: "Join Connect, It's Easy...!", textAlignment: .center, fontSize: 28)
    
    let nameLabel = CustomSecondaryTitleLabel(title: "NAME", fontSize: 16, textColor: .lightText)
    let nameTextField = CustomTextField(textAlignment: .left, fontSize: 16, placeholder: "Your name Here..")
    let nameLine = UIView()
    
    let emailLabel = CustomSecondaryTitleLabel(title: "EMAIL ADDRESS", fontSize: 16, textColor: .lightText)
    let emailTextField = CustomTextField(textAlignment: .left, fontSize: 16, placeholder: "EnterYourEmail")
    let emailLine   = UIView()
    
    let passwordLabel = CustomSecondaryTitleLabel(title: "PASSWORD", fontSize: 16, textColor: .lightText)
    let passwordTextField = CustomTextField(textAlignment: .left, fontSize: 16, placeholder: "******")
    
    let retypepasswordLabel = CustomSecondaryTitleLabel(title: "RETYPE PASSWORD", fontSize: 16, textColor: .lightText)
    let passwordTextFieldTwo = CustomTextField(textAlignment: .left, fontSize: 16, placeholder: "******")
    let passwordLine   = UIView()
    
    let firstTimeLabel = CustomSecondaryTitleLabel(title: "Already have an account...? ", fontSize: 16, textColor: .lightText)
    let wrongPassLabel = CustomSecondaryTitleLabel(title: "Something went wrong...", fontSize: 13, textColor: .systemRed)
    
    //MARK:- Buttons
    
    let backToSignInBtn =  CustomGenericButton(backgroundColor: .link, title: "Sign In")
    let signUpWEmailBtn =  CustomMainButton(backgroundColor: .clear, title: "Sign Up with email", textColor: .white, borderWidth: 0.3, borderColor: CustomColors.CustomGreen.cgColor, buttonImage: nil)
    var appleIDBtn = ASAuthorizationAppleIDButton()
    let facebookBtn = CustomGenericButton()
    let googleBtn =  CustomGenericButton()
    
    var isNameEntered: Bool { return !nameTextField.text!.isEmpty}
    var isEmailEntered: Bool { return !emailTextField.text!.isEmpty }
    var isPassOneEntered: Bool { return !passwordTextField.text!.isEmpty }
    var isPassTowEntered: Bool { return !passwordTextFieldTwo.text!.isEmpty }
    
    var ref: DatabaseReference!
    var userManager = UserManager.shared
    let firestore = FireStoreManager.shared
    let storage = FireStorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.backgroundColor = .systemBackground
    }
    
    //MARK:- UI ELEMENTS
    //MARK:- CONFIGURE UI ELEMENTS
    private func configure() {
        configureBackgroundImages()
        configureLabels()
        configureButtons()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wrongPassLabel.isHidden = true
        //        showLoadingView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        //        dismissLoadingView()
        //        isUserLoggedIn()
    }
    
    //MARK:- LABELS & TEXT FIELDS
    private func configureLabels() {
        //Labels & TextFields
        let textFields = [nameTextField, emailTextField, passwordTextField, passwordTextFieldTwo ]
        for field in textFields {
            field.translatesAutoresizingMaskIntoConstraints = false
            field.layer.borderWidth = 0
            field.backgroundColor = .clear
            field.textColor = .label
            field.returnKeyType = .go
            field.clearButtonMode = .whileEditing
            field.addTarget(self, action: #selector(textFieldAction), for: .primaryActionTriggered)
            view.addSubview(field)
        }
        emailTextField.delegate = self
        emailTextField.becomeFirstResponder()
        passwordTextField.delegate = self
        
        let labels = [titleLabel, nameLabel, emailLabel, passwordLabel, retypepasswordLabel, firstTimeLabel, wrongPassLabel]
        for label in labels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .secondaryLabel
            view.addSubview(label)
        }
        titleLabel.textColor = CustomColors.CustomBlue
        wrongPassLabel.textColor = UIColor.systemRed
        
        let lines = [nameLine, emailLine, passwordLine]
        for line in lines {
            line.backgroundColor = CustomColors.CustomGreenLightBright.withAlphaComponent(0.8)
            line.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(line)
        }
    }
    
    //MARK:- BUTTONS
    private func configureButtons() {
        //FORGOT BTN
        let buttons = [signUpWEmailBtn, backToSignInBtn, appleIDBtn, facebookBtn, googleBtn ]
        for button in buttons {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            view.addSubview(button)
        }
        
        
        //BACK TO SIGNIN BTN
        backToSignInBtn.addTarget(self, action: #selector(backTosignInAction), for: .touchUpInside)
        backToSignInBtn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        
        //SIGNIN WITH EMAIL BTN
        signUpWEmailBtn.addTarget(self, action: #selector(signUpWithEmail), for: .touchUpInside)
        signUpWEmailBtn.setBackgroundImage(Images.buttonActive, for: .normal)
        
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
        signUpWithEmail()
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
    @objc private func backTosignInAction() {
        
        print("going back")
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .custom
        loginVC.transitioningDelegate = self
        present(loginVC, animated: true)
        
    }
    
    //MARK:- FORGOT PASSWORD
    @objc private func thereIsAnError() {
        wrongPassLabel.isHidden = false
        print("there is an error")
    }
    
    //MARK: TRANSITIONS
    private func backToLoginViewController() {
        if let loginVC = storyboard?.instantiateViewController(identifier: CustomViewControllers.loginViewController) {
            loginVC.modalPresentationStyle = .custom
            loginVC.transitioningDelegate = self
            showDetailViewController(loginVC, sender: self)
        }
    }
    
    //MARK:- SIGNUP WITH EMAIL
    @objc private func signUpWithEmail() {
        print("signUPWithEmail")
        guard isNameEntered || isEmailEntered || isPassOneEntered || isPassTowEntered else {
            showAlert(title: "Empty Fields", message: "Please check your Name, Email & Password...!", buttonTitle: "Ok")
            wrongPassLabel.isHidden = false
            return
        }
        guard passwordTextField.text == passwordTextFieldTwo.text && passwordTextField.text!.count >= 6 && passwordTextFieldTwo.text!.count >= 6 else  {
            thereIsAnError()
            self.showAlert(title: "Something went wrong...", message: "pass are not equal & needs to be at least 8 characters", buttonTitle: "Return")
            print("pass are not equal & needs to be at least 8 chars")
            return
        }
        var newUser: User?
        
        if let userProfile = bubbleImageView.image,
            let name = nameTextField.text,
           let email = emailTextField.text,
           let passOne = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: passOne) { [weak self] authResult, error in
                guard let self = self else { return }
                if let unwrappedError = error {
                    self.thereIsAnError()
                    self.showAlert(title: "Something went wrong...", message: "\(unwrappedError.localizedDescription)", buttonTitle: "Return")
                    print(unwrappedError.localizedDescription)
                    return
                }
                
                //Get the UUID for the current user
                guard let uuid = authResult?.user.uid else {
                    return
                }
                
                
                
                self.storage.uploadSingleImage(userProfile) { (imageURL) in
                    let profileImage = imageURL

                    newUser = User(profileImage: profileImage, name: name, handler: "", email: email, password: passOne, bio: "", location: "", feedID: "", mainImage: "", otherImages: [""], status: "", postedOn: Date(), postTitle: "", messageDescription: "", likes: "", comments: "", views: "")
                    
                    
                   
                    
                guard let saveThisUser = newUser else { return}
                    
//                    self.storage.uploadProfileImage(user: saveThisUser) { (string) in
//                        print("Saved")
////                    }
                    self.firestore.saveUser(user: saveThisUser, userID: uuid) { (result) in
                    print("saved user")

                    print("Saved suscessfully into firebase database need an alert")
                    self.navigationController?.popViewController(animated: true)
                    let customTabVC = CustomTabBarController()
                    customTabVC.modalPresentationStyle = .custom
                    self.present(customTabVC, animated: true, completion: nil)
                    //                    self.showLoadingView()
                }
            }
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

extension SignUpViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
}

//MARK:- CUSTOM STORYBOARD ANIMATED TRANSITION
extension SignUpViewController: UIViewControllerTransitioningDelegate {
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
    @IBAction func unwindToExit(_ unwindSegue: UIStoryboardSegue) {}
}


extension SignUpViewController {
    //move this to an extenxion
    private func setupConstraints() {
        let padding: CGFloat = 20
        let textPadding:CGFloat = 8
        let textWidth: CGFloat = view.frame.width / 2.5
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
        
        //        MARK:- NAME, EMAIL TITLE & TEXTFIELD
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding * 1.7),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameTextField.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        
        NSLayoutConstraint.activate([
            nameLine.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLine.bottomAnchor, constant: padding),
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
            passwordLabel.widthAnchor.constraint(equalToConstant: textWidth)
            
        ])
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 2),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordTextField.widthAnchor.constraint(equalToConstant: textWidth),
            passwordTextField.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        
        NSLayoutConstraint.activate([
            retypepasswordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding),
            retypepasswordLabel.leadingAnchor.constraint(equalTo: passwordLabel.trailingAnchor, constant: padding),
            retypepasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
        ])
        NSLayoutConstraint.activate([
            passwordTextFieldTwo.topAnchor.constraint(equalTo: retypepasswordLabel.bottomAnchor, constant: 2),
            passwordTextFieldTwo.leadingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: padding),
            passwordTextFieldTwo.widthAnchor.constraint(equalToConstant: textWidth),
            passwordTextFieldTwo.heightAnchor.constraint(equalToConstant: customHeight)
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
            firstTimeLabel.widthAnchor.constraint(equalToConstant: textWidth * 1.2)
        ])
        NSLayoutConstraint.activate([
            wrongPassLabel.topAnchor.constraint(equalTo: firstTimeLabel.bottomAnchor, constant: textPadding + 2),
            wrongPassLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        //        MARK:- BUTTONS
        //        MARK:- BUTTONS
        
        NSLayoutConstraint.activate([
            backToSignInBtn.topAnchor.constraint(equalTo: passwordLine.bottomAnchor, constant: textPadding),
            backToSignInBtn.leadingAnchor.constraint(equalTo: firstTimeLabel.trailingAnchor, constant: padding),
            backToSignInBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            backToSignInBtn.heightAnchor.constraint(equalToConstant: 25)
            
        ])
        
        //SIGNWITH EMAIL
        NSLayoutConstraint.activate([
            signUpWEmailBtn.bottomAnchor.constraint(equalTo: appleIDBtn.topAnchor, constant: -textPadding),
            signUpWEmailBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: awayFromBorders),
            signUpWEmailBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -awayFromBorders),
            signUpWEmailBtn.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        
        //SIGNWITH APPLE ID
        NSLayoutConstraint.activate([
            appleIDBtn.bottomAnchor.constraint(equalTo: facebookBtn.topAnchor, constant: -textPadding),
            appleIDBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: awayFromBorders),
            appleIDBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -awayFromBorders),
            appleIDBtn.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        //SIGNWITH FACEBOOK
        NSLayoutConstraint.activate([
            facebookBtn.bottomAnchor.constraint(equalTo: googleBtn.topAnchor, constant: -textPadding),
            facebookBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: awayFromBorders),
            facebookBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -awayFromBorders),
            facebookBtn.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        //SIGNWITH GOOGLE
        NSLayoutConstraint.activate([
            googleBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding * 1.5),
            googleBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: awayFromBorders),
            googleBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -awayFromBorders),
            googleBtn.heightAnchor.constraint(equalToConstant: customHeight)
        ])
    }
}


/*                }
 
 ORIGINAL WAY OF SAVING
 //Suscess auth
//                self.ref = Database.database().reference(fromURL: "https://connect-f747d-default-rtdb.firebaseio.com/")
//                let usersReferences = self.ref.child("users").child(uuid)
//
//                let userReference = self.userManager.database.collection("users").document(uuid)
//                let values = ["name": name, "email": email]
//                userReference.updateData(values) { (error) in
//    //            userReference.updateChildValues(values) { (error, reference) in
//                    if let _ = error {
//                        print(error?.localizedDescription)
//                    }
//
//                usersReferences.updateChildValues(values) { (error, ref) in
//                    if let unwrappedError = error {
//                        self.showAlert(title: "Something is wrong...", message: "\(unwrappedError.localizedDescription)", buttonTitle: "Return")
//                        self.thereIsAnError()
//                        print(unwrappedError.localizedDescription)
//
//                        return
//                    }*/

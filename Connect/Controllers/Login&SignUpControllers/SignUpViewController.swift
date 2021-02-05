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
    let topBackgroundImage      = UIImageView()
    let bottomBackgroundImage   = UIImageView()
    let bubbleImageView         = UIImageView()
    let starsImage              = UIImageView()
    let addProfileImage         = CustomMainButton(backgroundColor: .clear, title: "", textColor: .white, borderWidth: 0, borderColor: UIColor.clear.cgColor, buttonImage: Images.greenPlus)
    let imagePicker = UIImagePickerController()
    private var currentButton: UIButton?

    
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
        signUpSetupConstraints()
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
        let buttons = [addProfileImage, signUpWEmailBtn, backToSignInBtn, appleIDBtn, facebookBtn, googleBtn ]
        for button in buttons {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            view.addSubview(button)
        }
        
        addProfileImage.addTarget(self, action: #selector(addProfileImageAction), for: .touchUpInside)
        
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
//        bubbleImageView.setImage(Images.bubbleImage, for: .normal)
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageView.backgroundColor = UIColor.clear
        bubbleImageView.clipsToBounds = true
        bubbleImageView.tintColor = CustomColors.CustomGreenLightBright.withAlphaComponent(0.8)
//        bubbleImageView.addTarget(self, action: #selector(addProfileImageAction), for: .touchUpInside)
        imagePicker.delegate = self
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
    
    //MARK:- ADD PROFILE IMAGE
    @objc private func addProfileImageAction()  {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- BACK TO SIGN IN
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
        var newUser: UserProfile?
        
        if let userProfile = bubbleImageView.image,
            let name = nameTextField.text,
           let email = emailTextField.text,
           let passOne = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: passOne) { authResult, error in
//                guard let self = self else { return }
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
                    
//                    let imageProfile = imageURL

                    newUser = UserProfile(userID: uuid, name: name, handler: "@\(name)", email: email, profileImage: imageURL, userLocation: "Florida", userBio: "Aqui", status: "Active")
                    
                guard let saveThisUser = newUser else { return}
                    
//                    self.storage.uploadProfileImage(user: saveThisUser) { (string) in
//                        print("Saved")
////                    }
                    self.userManager.saveUser(user: saveThisUser, userID: uuid) { (result) in
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


//MARK:- IMAGE PICKER DELEGATES
extension SignUpViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        print(image)
        picker.dismiss(animated: true) {
            self.bubbleImageView.image = image
//            self.currentButton!.setImage(image, for: .normal)

        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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

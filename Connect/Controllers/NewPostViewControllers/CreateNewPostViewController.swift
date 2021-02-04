//
//  CreateNewPostViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/26/21.
//

import UIKit
import FirebaseAuth


class CreateNewPostViewController: UIViewController, UITextFieldDelegate {
    
    let userProfileImageView    = CustomAvatarImage(frame: .zero)
    let mainImageViewArea       = CustomMainButton(backgroundColor: .lightGray, title: "", textColor: .white, borderWidth: 0.5, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: Images.greenPlus)
    let imageBtnOne             = CustomMainButton(backgroundColor: .lightGray, title: "", textColor: .white, borderWidth: 0.5, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: Images.greenPlus)
    let imageBtnTwo             = CustomMainButton(backgroundColor: .lightGray, title: "", textColor: .white, borderWidth: 0.5, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: Images.greenPlus)
    let imageBtnThree           = CustomMainButton(backgroundColor: .lightGray, title: "", textColor: .white, borderWidth: 0.5, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: Images.greenPlus)
    let userNameLabel           = CustomTitleLabel(title: "", textAlignment: .left, fontSize: 16)
    let statusLabel             = CustomSubtitleLabel(fontSize: 14, backgroundColor: .clear)
    let locationLabel           = CustomSecondaryTitleLabel(title: "", fontSize: 13, textColor: .label)
    let titleLabel              = CustomSecondaryTitleLabel(title: "", fontSize: 13, textColor: .label)
    let descriptionLabel        = CustomTextView(textAlignment: .left, fontSize: 13)
    let hashtagLabel            = CustomSecondaryTitleLabel(title: "", fontSize: 13, textColor: .label)
    let tagFriendsLabel         = CustomSecondaryTitleLabel(title: "", fontSize: 13, textColor: .label)
        
    //textFields
    let titleField              = CustomTextField(textAlignment: .left, fontSize: 15, placeholder: "Give it a Title...")
    let descriptionField        = CustomTextField(textAlignment: .left, fontSize: 14, placeholder: "Description...!")
    let hashtagField            = CustomTextField(textAlignment: .left, fontSize: 14, placeholder: "Hashtag...!")
    let tagFriendsField         = CustomTextField(textAlignment: .left, fontSize: 14, placeholder: "tag Some Friends...!")
    
    let storage                 = FireStorageManager.shared
    let firestore               = FireStoreManager.shared
    let userManager             = UserManager.shared
    let newPost                 = [UserProfile]()
    
    let imagePicker = UIImagePickerController()
    private var currentButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(colorTop: .systemGreen, colorBottom: .systemBlue)
//        guard let userProfile = user else { return }
//        print(userProfile)
        let currentUser = userManager.currentUserProfile
        configure(with: currentUser)
        imagePicker.delegate = self
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismisVC))
        navigationItem.leftBarButtonItem = cancelBtn
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveNewPost))
        navigationItem.rightBarButtonItem = saveBtn
    }
    
    private func configure(with userProfile: UserProfile?) {
        guard let user = userProfile else { return }
        self.view.addBottomBorderWithColor(color: CustomColors.CustomGreen, width: 1, alpha: 0.7)
        //PROFILE PICTURE
        view.addSubview(userProfileImageView)
        userProfileImageView.downloadImage(from: user.profileImage.absoluteString)
        
        //MEDIA VIEW AREA
        mainImageViewArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainImageViewArea)
        
        //LABELS
        userNameLabel.text = user.name
        statusLabel.text = "Privacy" //user.status ??
        locationLabel.text = "get current Location"// user.userLocation ?? "location"
        titleLabel.text = "Title label"
        descriptionLabel.text = "Description"
        hashtagLabel.text = "Hashtag"
        tagFriendsLabel.text = "Tag some friends in this post"
        
        let labels = [userNameLabel, statusLabel, locationLabel, titleLabel, descriptionLabel, hashtagLabel, tagFriendsLabel]
        for label in labels {
            view.addSubview(label)
        }
//        descriptionLabel.numberOfLines = 2
//        descriptionLabel.lineBreakMode = .byTruncatingTail
        configureTextField()
        setupActionButtons()
        setupConstraints()
    }
    
    private func configureTextField() {
        titleField.becomeFirstResponder()
        titleField.delegate = self
        let textFields = [titleField, descriptionField, descriptionField, hashtagField, tagFriendsField]
        for fields in textFields {
        view.addSubview(fields)
        }
   
    }
    
    fileprivate func setupActionButtons() {
        let actionButtons = [mainImageViewArea, imageBtnOne, imageBtnTwo, imageBtnThree]
        
        for button in actionButtons {
            view.addSubview(button)
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.imageView?.contentMode = .scaleAspectFit
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTopBorderWithColor(color: .blue, width: 2, alpha: 0.5)
            button.addTarget(self, action: #selector(getImage), for: .touchUpInside)
        }
        
    }
    
    @objc private func saveNewPost() {
        print("Clicked Save Btn 'Done'")
        self.dismisVC()
        createNewPost()
    }
    
    
    private func createNewPost() {
        if let mainImage         = mainImageViewArea.currentImage,
           let imageOne         = imageBtnOne.currentImage,
           let imageTwo         = imageBtnTwo.currentImage,
           let imageThree       = imageBtnThree.currentImage,
           let status           = statusLabel.text,
           let location         = self.locationLabel.text,
           let postTitle        = titleField.text,
           let postDescription  = descriptionField.text {
            
            storage.bulkUpload([mainImage, imageOne, imageTwo, imageThree]) { (urlPath) in

                let mainImg         = urlPath[0]
                let imgOne          = urlPath[1]
                let imgTwo           = urlPath[2]
                let imgThree         = urlPath[3]
                let otherImagesPaths = [imgOne, imgTwo, imgThree]
                print("urlPath :", urlPath)
                let postedOn        = "timestamp"
                let likes           = 0
                let comments        = 0
                let views           = 0
                
                guard let userProfile = self.userManager.currentUserProfile else { return }
                print("User Profile", userProfile)
                let newPost: [String: Any] = [
                    "author": [
                        "userID": userProfile.userID,
                        "name"  : userProfile.name,
                        "profileImage": userProfile.profileImage.absoluteString
                    ],
                    "mainImage      " : mainImg,
                    "otherImages    " : otherImagesPaths,
                    "status         " : status,
                    "postedOn       " : postedOn,
                    "location       " : location,
                    "postTitle      " : postTitle,
                    "postDescription" : postDescription,
                    "likes          " : likes,
                    "comments       " : comments,
                    "views          " : views
                ]
                self.firestore.savePost(post: newPost) { (result) in
                    print("result: ", result)
                }
                //WHEN SAVING I NEED TO SEE THE POST AUTOMATICALLY IN THE SAVED POSTS VIEW CONTROLLER
                
                //                    Feed(author: author, mainImage: mainImg, otherImages: otherImagesPaths, status: status, postedOn: postedOn, location: location, postTitle: postTitle, postDescription: postDescription, likes: likes, comments: comments, views: views)
                //
            }
        }
        
    }
    
    
    @objc private func getImage(_ sender: UIButton) {
        currentButton = sender
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}


extension CreateNewPostViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        print(image)
        picker.dismiss(animated: true) {
            self.currentButton!.setImage(image, for: .normal)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        let verticalPadding: CGFloat = 5
        let mediaHeight: CGFloat = view.frame.height / 8
        let mediaWidth: CGFloat = (view.frame.width / 4) - 5
        let mediaPadding: CGFloat = 4
        let fieldHeight: CGFloat = 30
        
        //ProfileImage
        NSLayoutConstraint.activate([
            
            
            userProfileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            userProfileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 70),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        //User name Label
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userProfileImageView.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: padding),
            
        ])
        
        
        
        //status Label
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: padding),
            statusLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: padding),
        ])
        
        //Location Label
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
        
        
        //MediaViewArea
        NSLayoutConstraint.activate([
            mainImageViewArea.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: padding),
            mainImageViewArea.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: mediaPadding),
            mainImageViewArea.widthAnchor.constraint(equalToConstant: mediaWidth),
            mainImageViewArea.heightAnchor.constraint(equalToConstant: mediaHeight)
        ])
        
        //Button One
        NSLayoutConstraint.activate([
            imageBtnOne.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: padding),
            imageBtnOne.leadingAnchor.constraint(equalTo: mainImageViewArea.trailingAnchor, constant: mediaPadding),
            imageBtnOne.widthAnchor.constraint(equalToConstant: mediaWidth),
            imageBtnOne.heightAnchor.constraint(equalToConstant: mediaHeight)
        ])
        
        //Button Tow
        NSLayoutConstraint.activate([
            imageBtnTwo.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: padding),
            imageBtnTwo.leadingAnchor.constraint(equalTo: imageBtnOne.trailingAnchor, constant: mediaPadding),
            imageBtnTwo.widthAnchor.constraint(equalToConstant: mediaWidth),
            imageBtnTwo.heightAnchor.constraint(equalToConstant: mediaHeight)
        ])
        
        //Button Three
        NSLayoutConstraint.activate([
            imageBtnThree.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: padding),
            imageBtnThree.leadingAnchor.constraint(equalTo: imageBtnTwo.trailingAnchor, constant: mediaPadding),
            imageBtnThree.widthAnchor.constraint(equalToConstant: mediaWidth),
            imageBtnThree.heightAnchor.constraint(equalToConstant: mediaHeight)
        ])
        
        
        
        
        //Title Label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageBtnThree.bottomAnchor, constant: verticalPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
        ])
        //Title Field
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleField.heightAnchor.constraint(equalToConstant: fieldHeight)
        ])
        
        //Description Label
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: verticalPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
        
        //Description Field
        NSLayoutConstraint.activate([
            descriptionField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 2),
            descriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            descriptionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            descriptionField.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        //Description Label
        NSLayoutConstraint.activate([
            hashtagLabel.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: verticalPadding),
            hashtagLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            hashtagLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
        
        //Description Field
        NSLayoutConstraint.activate([
            hashtagField.topAnchor.constraint(equalTo: hashtagLabel.bottomAnchor, constant: 2),
            hashtagField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            hashtagField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            hashtagField.heightAnchor.constraint(equalToConstant: fieldHeight)
        ])
        
        //Description Label
        NSLayoutConstraint.activate([
            tagFriendsLabel.topAnchor.constraint(equalTo: hashtagField.bottomAnchor, constant: verticalPadding),
            tagFriendsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tagFriendsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
        
        //Description Field
        NSLayoutConstraint.activate([
            tagFriendsField.topAnchor.constraint(equalTo: tagFriendsLabel.bottomAnchor, constant: 2),
            tagFriendsField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tagFriendsField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            tagFriendsField.heightAnchor.constraint(equalToConstant: fieldHeight)
        ])
        
        
        
    }
    
    @objc func dismisVC() {
        self.dismiss(animated: true, completion: nil)
    }
}

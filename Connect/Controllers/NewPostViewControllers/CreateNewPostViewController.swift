//
//  CreateNewPostViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/26/21.
//

import UIKit
import FirebaseAuth


class CreateNewPostViewController: UIViewController, UITextFieldDelegate {

    let userProfileImageView         = CustomAvatarImage(frame: .zero)
    let mainImageViewArea       = CustomMainButton(backgroundColor: .lightGray, title: "", textColor: .white, borderWidth: 0.5, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: Images.greenPlus)
    let imageBtnOne         = CustomMainButton(backgroundColor: .lightGray, title: "", textColor: .white, borderWidth: 0.5, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: Images.greenPlus)
    let imageBtnTwo         = CustomMainButton(backgroundColor: .lightGray, title: "", textColor: .white, borderWidth: 0.5, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: Images.greenPlus)
    let imageBtnThree       = CustomMainButton(backgroundColor: .lightGray, title: "", textColor: .white, borderWidth: 0.5, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: Images.greenPlus)
    let userNameLabel       = CustomTitleLabel(title: "", textAlignment: .left, fontSize: 16)
    let statusLabel         = CustomSubtitleLabel(fontSize: 14, backgroundColor: .clear)
    let locationLabel       = CustomSecondaryTitleLabel(title: "", fontSize: 13, textColor: .systemGray)
    let titleLabel          = CustomSecondaryTitleLabel(title: "", fontSize: 13, textColor: .label)
    let descriptionLabel    = CustomSecondaryTitleLabel(title: "", fontSize: 13, textColor: .label)
    
    //textFields
    let titleField          = CustomTextField(textAlignment: .left, fontSize: 15, placeholder: "Give it a Title...")
    let descriptionField    = CustomTextField(textAlignment: .left, fontSize: 14, placeholder: "Description...!")
    
    var user: User?
    let storage = FireStorageManager.shared
    let firestore = FireStoreManager.shared
    let newPost = [User]()

    let imagePicker = UIImagePickerController()
    private var currentButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground(colorTop: .systemGreen, colorBottom: .systemBlue)
        configure()
        imagePicker.delegate = self
        configureNavigationBar()
//        firestore.configure()
        print(firestore)
        print(storage)
    }
    
    private func configureNavigationBar() {
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismisVC))
        navigationItem.leftBarButtonItem = cancelBtn
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveNewPost))
        navigationItem.rightBarButtonItem = saveBtn
    }
  
    private func configure() {
        self.view.addBottomBorderWithColor(color: CustomColors.CustomGreen, width: 1, alpha: 0.7)
        //PROFILE PICTURE
        view.addSubview(userProfileImageView)
        userProfileImageView.image = UIImage(named: user?.profileImage ?? Images.Avatar)

        //MEDIA VIEW AREA
        mainImageViewArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainImageViewArea)
        
        //LABELS
        userNameLabel.text = "Leandro Diaz"
        statusLabel.text = "Status"
        locationLabel.text = "Location"
        titleLabel.text = "Title label"
        descriptionLabel.text = "Description"
               
        let labels = [userNameLabel, statusLabel, locationLabel, titleLabel, descriptionLabel]
        for label in labels {
            view.addSubview(label)
        }
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byTruncatingTail
        configureTextField()
        setupActionButtons()
        setupConstraints()
    }
    
    private func configureTextField() {
        titleField.becomeFirstResponder()
        titleField.delegate = self
//        textFields
             view.addSubview(titleField)
        view.addSubview(descriptionField)
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
        //        self.navigationController?.dismiss(animated: true, completion: nil)
        self.dismisVC()
        var newPost: [User]?
        var newUser: User?
        
        if let name             = self.userNameLabel.text,
           let profileImage     = self.userProfileImageView.image,
           let location         = self.locationLabel.text,
           let title            = titleField.text,
           
           let mainImage        = mainImageViewArea.currentImage,
           let imageOne         = imageBtnOne.currentImage,
           let imageTwo         = imageBtnTwo.currentImage,
           let imageThree       = imageBtnThree.currentImage,
           let status           = statusLabel.text,
           let descriptionField = descriptionField.text {
            
            
            storage.bulkUpload([profileImage, mainImage, imageOne, imageTwo, imageThree]) {  (urlPath) in
                //            guard let self = self else { return }
                let profImg     = urlPath[0]
                let imgOne      = urlPath[1]
                let imgTwo      = urlPath[2]
                let imgThree    = urlPath[3]
                let imgFour     = urlPath[4]
                let otherImagesPaths = [imgTwo, imgThree, imgFour]
                print("urlPath :", urlPath)
                
                
                newUser = User( profileImage: profImg, name: name, handler: "", email: "", password: nil, bio: "", location: location, feedID: UUID().uuidString, mainImage: imgOne, otherImages: otherImagesPaths, status: status, postedOn: Date(), postTitle: title, messageDescription: descriptionField, likes: "1", comments: "1", views: "1")
                guard let userID = Auth.auth().currentUser?.uid else { return }
                guard let newUserPost = newUser else { return }
                self.firestore.saveFeeds(userID: userID, feeds: newUserPost ) { (result) in
                    print("Saved Sucessfully")
                }
            }
            
        } 
    }
    

    
//    @objc func savePost() {
//        print("Clicked Save Btn 'Done'")
//        self.navigationController?.dismiss(animated: true, completion: nil)
//        print(mediaViewArea)
//        guard
//              let title = titleField.text,
//              let curStatus = statusLabel.text,
//              let curLocation = locationLabel.text,
//              let mainImage = mediaViewArea.currentImage
//              let imageOne = imageBtnOne.currentImage,
//              let imageTwo = imageBtnTwo.currentImage,
//              let imageThree = imageBtnThree.currentImage,
//              let description = descriptionField.text
        
//        else {
//            print(self.mediaViewArea)
//            return }
//        print(mainImage)
//
//        storage.bulkUpload([mainImage /*, imageOne, imageTwo, imageThree*/]) { [weak self] (urlPath) in
////            guard let self = self else { return }
//            let imgOne = urlPath[0]
//            let imgTwo = urlPath[1]
//            let imgThree = urlPath[2]
//            let imgFour = urlPath[3]
//      print("urlPath :", urlPath)
            
//            let postObj = Feed(userName: User(profileImage: self?.user?.profileImage ?? Images.Avatar, name: self?.user?.name ?? "", handler: self?.user?.handler ?? "", bio: ""), profile: "", media: imgOne, otherImages: Array(urlPath.suffix(from: 0)), status: "curStatus", postedOn: String(Date().timeIntervalSinceNow), location: "curLocation", postTitle: "title", description: "description", likes: "0", comments: "", views: "")
//            print(postObj)
            
           
//            self?.firestore.saveFeeds(postObj) { (result) in
//
//                print("result :", result)
//                self?.navigationController?.popViewController(animated: true)
////            }
//        }
//        }
//
//      print(mainImage)
//    }

    
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
//            self.mainImageViewArea.setImage(image, for: .normal)
            print(self.currentButton)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        let mediaHeight: CGFloat = view.frame.height / 4
        
        //ProfileImage
        NSLayoutConstraint.activate([

            
            userProfileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            userProfileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 40),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        //User name Label
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userProfileImageView.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: padding),

        ])
        

        
        //status Label
        NSLayoutConstraint.activate([
            statusLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: padding),
        ])
        
        //Location Label
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            locationLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: padding),
        ])
        
        
        //MediaViewArea
        NSLayoutConstraint.activate([
            mainImageViewArea.topAnchor.constraint(equalTo: userProfileImageView.bottomAnchor, constant: padding),
            mainImageViewArea.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            mainImageViewArea.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            mainImageViewArea.heightAnchor.constraint(equalToConstant: mediaHeight)
        ])
        
        //Button One
        NSLayoutConstraint.activate([
            imageBtnOne.topAnchor.constraint(equalTo: mainImageViewArea.bottomAnchor, constant: padding),
            imageBtnOne.trailingAnchor.constraint(equalTo: imageBtnTwo.leadingAnchor, constant: -padding),
            imageBtnOne.widthAnchor.constraint(equalToConstant: 100),
            imageBtnOne.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        //Button Tow
        NSLayoutConstraint.activate([
            imageBtnTwo.topAnchor.constraint(equalTo: mainImageViewArea.bottomAnchor, constant: padding),
            imageBtnTwo.centerXAnchor.constraint(equalTo: mainImageViewArea.centerXAnchor),
            imageBtnTwo.widthAnchor.constraint(equalToConstant: 100),
            imageBtnTwo.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        //Button Three
        NSLayoutConstraint.activate([
            imageBtnThree.topAnchor.constraint(equalTo: mainImageViewArea.bottomAnchor, constant: padding),
            imageBtnThree.leadingAnchor.constraint(equalTo: imageBtnTwo.trailingAnchor, constant: padding),
            imageBtnThree.widthAnchor.constraint(equalToConstant: 100),
            imageBtnThree.heightAnchor.constraint(equalToConstant: 100)
        ])
        
       

        
        //Title Label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageBtnOne.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
        ])
        //Title Field
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        //Description Label
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
        
        //Description Field
        NSLayoutConstraint.activate([
            descriptionField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 2),
            descriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            descriptionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            descriptionField.heightAnchor.constraint(equalToConstant: 30)
        ])
 
    }
    
    @objc func dismisVC() {
        self.dismiss(animated: true, completion: nil)
    }
}

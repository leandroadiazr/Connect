//
//  CreateViewCell.swift
//  Connect
//
//  Created by Leandro Diaz on 2/4/21.
//

import UIKit

class CreateViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let reuseID = "CreateViewCell"
    let userProfileImageView    = CustomAvatarImage(frame: .zero)
    let mainImageViewArea       = CustomMainButton(backgroundColor: .lightGray, title: "", textColor: .white, borderWidth: 0.5, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: Images.greenPlus)
    let imageBtnOne             = CustomMainButton(backgroundColor: .lightGray, title: "", textColor: .white, borderWidth: 0.5, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: Images.greenPlus)
    let imageBtnTwo             = CustomMainButton(backgroundColor: .lightGray, title: "", textColor: .white, borderWidth: 0.5, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: Images.greenPlus)
    let imageBtnThree           = CustomMainButton(backgroundColor: .lightGray, title: "", textColor: .white, borderWidth: 0.5, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: Images.greenPlus)
    let userNameLabel           = CustomTitleLabel(title: "", textAlignment: .left, fontSize: 16)
    let statusLabel             = CustomSubtitleLabel(fontSize: 14, backgroundColor: .clear)
    let locationLabel           = CustomSecondaryTitleLabel(title: "", fontSize: 13, textColor: .systemGray)
    let titleLabel              = CustomSecondaryTitleLabel(title: "", fontSize: 13, textColor: .label)
    let descriptionLabel        = CustomSecondaryTitleLabel(title: "", fontSize: 13, textColor: .label)
        
    //textFields
    let titleField              = CustomTextField(textAlignment: .left, fontSize: 15, placeholder: "Give it a Title...")
    let descriptionField        = CustomTextField(textAlignment: .left, fontSize: 14, placeholder: "Description...!")
    let firestore               = FireStoreManager.shared
    let userManager             = UserManager.shared
    let imagePicker = UIImagePickerController()
    private var currentButton: UIButton?
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            let currentUser = userManager.currentUserProfile
            configure(with: currentUser)
        }
       
       override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }

    
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       func configureMovieCell() {
          
   //        titleLabel.text = movies.title
   //        detailsLabel.text = movies.year
   //        viewImage.downloadImage(from: movies.poster)
       }
       
       func configure(with userProfile: UserProfile?) {
        guard let user = userProfile else { return }
        self.addBottomBorderWithColor(color: CustomColors.CustomGreen, width: 1, alpha: 0.7)
        //PROFILE PICTURE
        addSubview(userProfileImageView)
        userProfileImageView.downloadImage(from: user.profileImage.absoluteString)
        
        //MEDIA VIEW AREA
        mainImageViewArea.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainImageViewArea)
        
        //LABELS
        userNameLabel.text = user.name
        statusLabel.text = user.status
        locationLabel.text = user.userLocation
        titleLabel.text = "Title label"
        descriptionLabel.text = "Description"
        
        let labels = [userNameLabel, statusLabel, locationLabel, titleLabel, descriptionLabel]
        for label in labels {
            addSubview(label)
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
        addSubview(titleField)
        addSubview(descriptionField)
    }
    
    fileprivate func setupActionButtons() {
        let actionButtons = [mainImageViewArea, imageBtnOne, imageBtnTwo, imageBtnThree]
        
        for button in actionButtons {
            addSubview(button)
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            button.imageView?.contentMode = .scaleAspectFit
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTopBorderWithColor(color: .blue, width: 2, alpha: 0.5)
            button.addTarget(self, action: #selector(getImage), for: .touchUpInside)
        }
        
    }
    
    @objc private func getImage(_ sender: UIButton) {
        currentButton = sender
        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
    }
    
    
       private func setupConstraints() {
        let padding: CGFloat = 10
        let mediaHeight: CGFloat = contentView.frame.height / 4
        
        //ProfileImage
        NSLayoutConstraint.activate([
            
            
            userProfileImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            userProfileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 50),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 50)
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
            mainImageViewArea.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            mainImageViewArea.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
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
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
        ])
        //Title Field
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            titleField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            titleField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        //Description Label
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
        ])
        
        //Description Field
        NSLayoutConstraint.activate([
            descriptionField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 2),
            descriptionField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            descriptionField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            descriptionField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
}

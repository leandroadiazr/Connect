//
//  CommentsViewController.swift
//  Connect
//
//  Created by Leandro Diaz on 2/3/21.
//

import UIKit

class CommentsViewController: UIViewController {
    
    let containerview   = AlertContainerView()
    let profileImage    = CustomAvatarImage(frame: .zero)
    let titleLabel      = CustomSecondaryTitleLabel(title: "Leave your Comment...", fontSize: 14, textColor: .label)
    let messageArea     = CustomTextView(textAlignment: .left, fontSize: 13)
    let actionButton    = CustomMainButton(backgroundColor: CustomColors.CustomGreenGradient, title: "", textColor: .white, borderWidth: 0, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: nil)
    
    var message: String?
    var buttonTitle: String?
    
    init(message: String, buttonTitle: String){
        super.init(nibName: nil, bundle: nil)
        self.message        = message
        self.buttonTitle    = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureProfileImage()
        configureActionButton()
        configureMessageArea()
        setupConstraints()
    }
    
    func configureContainerView(){
        view.addSubview(containerview)
    }
    
    func configureProfileImage(){
        containerview.addSubview(profileImage)
        profileImage.image = UIImage(named: Images.profilePic)
    }
    
    func configureActionButton(){
        containerview.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    func configureMessageArea(){
        containerview.addSubview(titleLabel)
        containerview.addSubview(messageArea)
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    
    
    private func setupConstraints(){
        let padding: CGFloat = 10
        //Container View Constraints
        NSLayoutConstraint.activate([
            containerview.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerview.widthAnchor.constraint(equalToConstant: 320),
            containerview.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        //Title Label Constraints
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: containerview.topAnchor, constant: padding),
            profileImage.leadingAnchor.constraint(equalTo: containerview.leadingAnchor, constant: padding),
            profileImage.widthAnchor.constraint(equalToConstant: 35),
            profileImage.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        //Title Label Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerview.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerview.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        // Action Button Constraints
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerview.bottomAnchor, constant: -padding),
            actionButton.widthAnchor.constraint(equalToConstant: 70),
            actionButton.trailingAnchor.constraint(equalTo: containerview.trailingAnchor, constant: -padding),
            //            actionButton.heightAnchor.constraint(equalToConstant: )
        ])
        
        //Message Label Constraints
        NSLayoutConstraint.activate([
            messageArea.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: padding),
            messageArea.leadingAnchor.constraint(equalTo: containerview.leadingAnchor, constant: padding),
            messageArea.trailingAnchor.constraint(equalTo: containerview.trailingAnchor, constant: -padding),
            messageArea.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -padding)
        ])
        
    }
    
}

//
//  AlertViewController.swift
//  Content
//
//  Created by Leandro Diaz on 1/20/21.
//

import UIKit

class AlertViewController: UIViewController {
    let containerview = AlertContainerView()
    let titleLabel = CustomTitleLabel(title: "", textAlignment: .center, fontSize: 20)
    let messageLabel = CustomBodyLabel(textAlignment: .center, backgroundColor: .clear, fontSize: 16)
    let actionButton = CustomMainButton(backgroundColor: .systemRed, title: "", textColor: .white, borderWidth: 0, borderColor: CustomColors.CustomGreenLightBright.cgColor, buttonImage: nil)
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    init(alertTitle: String, message: String, buttonTitle: String){
        super.init(nibName: nil, bundle: nil)
        self.alertTitle     = alertTitle
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
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
        setupConstraints()
    }
    
    
    func configureContainerView(){
        view.addSubview(containerview)
    }
    
    
    func configureTitleLabel(){
        containerview.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong"
    }
    
    
    func configureActionButton(){
        containerview.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    
    func configureMessageLabel(){
        containerview.addSubview(messageLabel)
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
    }
    
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    
    
    private func setupConstraints(){
        let padding: CGFloat = 20
        //Container View Constraints
        NSLayoutConstraint.activate([
            containerview.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerview.widthAnchor.constraint(equalToConstant: 320),
            containerview.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        //Title Label Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerview.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerview.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerview.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        // Action Button Constraints
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerview.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerview.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerview.trailingAnchor, constant: -padding),
//            actionButton.heightAnchor.constraint(equalToConstant: )
        ])
        
        //Message Label Constraints
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerview.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerview.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -8)
        ])
    }
}

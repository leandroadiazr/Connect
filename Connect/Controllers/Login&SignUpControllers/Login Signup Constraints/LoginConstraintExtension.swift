//
//  LoginConstraintExtension.swift
//  Connect
//
//  Created by Leandro Diaz on 2/1/21.
//

import UIKit

extension LoginViewController {
    //move this to an extenxion
     func LoginSetupConstraints() {
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
            titleLabel.topAnchor.constraint(equalTo: bubbleImageView.bottomAnchor, constant: 30),
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
            goToSignUpBtn.topAnchor.constraint(equalTo: passwordLine.bottomAnchor, constant: textPadding),
            goToSignUpBtn.leadingAnchor.constraint(equalTo: firstTimeLabel.trailingAnchor, constant: 2),
            goToSignUpBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            goToSignUpBtn.heightAnchor.constraint(equalToConstant: 35)
            
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
//
//  SignUpConstraintExtension.swift
//  Connect
//
//  Created by Leandro Diaz on 2/1/21.
//

import UIKit

extension SignUpViewController {
    //move this to an extenxion
    
    func signUpSetupConstraints() {
        
        let padding: CGFloat = 20
        let textPadding:CGFloat = 8
        let textWidth: CGFloat = view.frame.width / 2.5
        let customHeight: CGFloat = 45
        let topHalf: CGFloat = view.frame.height / 6.7
        let awayFromBorders: CGFloat = 100
        
        let lastButtonBottomConstraints: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed || DeviceTypes.isiPhoneX ? padding * 2 : padding * 3.7
        
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
        
        //MARK:- PROFILE IMAGE
        NSLayoutConstraint.activate([
            addProfileImage.bottomAnchor.constraint(equalTo: bubbleImageView.bottomAnchor, constant: 5),
            addProfileImage.centerXAnchor.constraint(equalTo: bubbleImageView.trailingAnchor, constant:  -10),
            addProfileImage.widthAnchor.constraint(equalToConstant: 35),
            addProfileImage.heightAnchor.constraint(equalToConstant: 35)
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
        
        //        MARK:- NAME, EMAIL TITLE & TEXTFIELD
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: textPadding),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
        NSLayoutConstraint.activate([
            nameTextField.bottomAnchor.constraint(equalTo: nameLine.topAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameTextField.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        
        NSLayoutConstraint.activate([
            nameLine.bottomAnchor.constraint(equalTo: emailLabel.topAnchor, constant: -textPadding),
            nameLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        NSLayoutConstraint.activate([
            emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: textPadding),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
        NSLayoutConstraint.activate([
            emailTextField.bottomAnchor.constraint(equalTo: emailLine.topAnchor, constant: 5),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        NSLayoutConstraint.activate([
            emailLine.bottomAnchor.constraint(equalTo: passwordLabel.topAnchor, constant: -textPadding),
            emailLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            emailLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        //        MARK:- PASSWORD TITLE & TEXTFIELD
        NSLayoutConstraint.activate([
            passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: textPadding),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordLabel.widthAnchor.constraint(equalToConstant: textWidth)
            
        ])
        NSLayoutConstraint.activate([
            passwordTextField.bottomAnchor.constraint(equalTo: passwordLine.topAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordTextField.widthAnchor.constraint(equalToConstant: textWidth),
            passwordTextField.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        
        NSLayoutConstraint.activate([
            retypepasswordLabel.bottomAnchor.constraint(equalTo: passwordTextFieldTwo.topAnchor, constant: textPadding),
            retypepasswordLabel.leadingAnchor.constraint(equalTo: passwordLabel.trailingAnchor, constant: padding),
            retypepasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
        ])
        NSLayoutConstraint.activate([
            passwordTextFieldTwo.bottomAnchor.constraint(equalTo: passwordLine.topAnchor, constant: 5),
            passwordTextFieldTwo.leadingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: padding),
            passwordTextFieldTwo.widthAnchor.constraint(equalToConstant: textWidth),
            passwordTextFieldTwo.heightAnchor.constraint(equalToConstant: customHeight)
        ])
        
        //        MARK:- MESSAGE AND ERROR LABELS
        NSLayoutConstraint.activate([
            wrongPassLabel.bottomAnchor.constraint(equalTo: signUpWEmailBtn.topAnchor, constant: -textPadding + 2),
            wrongPassLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            passwordLine.bottomAnchor.constraint(equalTo: backToSignInBtn.topAnchor, constant: -textPadding),
            passwordLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            passwordLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            passwordLine.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        NSLayoutConstraint.activate([
            firstTimeLabel.topAnchor.constraint(equalTo: backToSignInBtn.topAnchor ),
            firstTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            firstTimeLabel.widthAnchor.constraint(equalToConstant: textWidth * 1.2)
        ])
        
        //        MARK:- BUTTONS
        //        MARK:- BUTTONS        
        NSLayoutConstraint.activate([
            backToSignInBtn.bottomAnchor.constraint(equalTo: signUpWEmailBtn.topAnchor, constant: -lastButtonBottomConstraints),
            backToSignInBtn.leadingAnchor.constraint(equalTo: firstTimeLabel.trailingAnchor, constant: padding),
            backToSignInBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            backToSignInBtn.heightAnchor.constraint(equalToConstant: 35)
            
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

//
//  CustomChatCell.swift
//  Connect
//
//  Created by Leandro Diaz on 2/28/21.
//

import UIKit

protocol ZoomFunction: class {
    func implementZoomIn(image: UIImageView)
}

class CustomChatCell: UICollectionViewCell {
    static let reuseID = "CustomChatCell"
    
    var usersManager    = UserManager.shared
    let mediaView       = GenericImageView(frame: .zero)
    weak var zoomDelegate: ZoomFunction?
    
    let profileImage    : UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 17.5
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = CustomColors.CustomGreenLightBright.cgColor
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let senderBubble : UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
//    main view
    var textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
   
    var messageText: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .white
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    let bubbleView      : UIView = {
       let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .systemGreen
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configureGrid(with chat: Messages) {
        messageText.text = chat.textMessage
        
        if let imageURL = chat.media {
            mediaView.cacheImage(from: imageURL)
            textBubbleView.backgroundColor = .clear
        }
    }

    private func configure() {
        addSubview(profileImage)
        addSubview(textBubbleView)
        messageText.backgroundColor = .clear
        addSubview(messageText)
        messageText.layer.borderWidth = 0
        mediaView.layer.borderWidth = 0
        mediaView.isUserInteractionEnabled = false
//        mediaView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoom(tapGesture:))))
        textBubbleView.addSubview(mediaView)
        setupConstraints()
    }
    
    private func setupConstraints() {

        NSLayoutConstraint.activate([
            mediaView.topAnchor.constraint(equalTo: textBubbleView.topAnchor, constant: 2),
            mediaView.leadingAnchor.constraint(equalTo: textBubbleView.leadingAnchor, constant: 2),
            mediaView.trailingAnchor.constraint(equalTo: textBubbleView.trailingAnchor, constant: -2),
            mediaView.bottomAnchor.constraint(equalTo: textBubbleView.bottomAnchor, constant: -2)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImage.image = nil
        self.messageText.text = nil
    }
    
    
    @objc private func handleZoom(tapGesture: UITapGestureRecognizer) {
        print("image tapped")
//        guard let imageView = tapGesture.view as? UIImageView else { return }
//        self.zoomDelegate?.implementZoomIn(image: imageView)
    }
    
}

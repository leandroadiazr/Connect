//
//  DetailsViewCell.swift
//  Connect
//
//  Created by Leandro Diaz on 2/3/21.
//

import UIKit

protocol DetailsAction: class {
    func detailsAction()
}

class DetailsViewCell: UICollectionViewCell {
    static let reuseID          = "DetailsViewCell"
    
    let mainImageViewArea       = GenericImageView(frame: .zero)
    let imageViewAreaTwo        = GenericImageView(frame: .zero)
    let imageViewAreaThree      = GenericImageView(frame: .zero)
    let imageViewAreaFour       = GenericImageView(frame: .zero)
    let titleLabel              = CustomSecondaryTitleLabel(title: "", fontSize: 15, textColor: .label)
    let locationLabel           = CustomSecondaryTitleLabel(title: "", fontSize: 12, textColor: .systemGray)
    let messageDescriptionLabel = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 11)
    let likesLabel              = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 10)
    var likesCounter            = CustomBodyLabel(textAlignment: .center, backgroundColor: .clear, fontSize: 12)
    let commentsLabel           = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 10)
    var commentsCounter         = CustomBodyLabel(textAlignment: .center, backgroundColor: .clear, fontSize: 12)
    let viewsLabel              = CustomBodyLabel(textAlignment: .right, backgroundColor: .clear, fontSize: 10)
    var viewsCounter            = CustomBodyLabel(textAlignment: .center, backgroundColor: .clear, fontSize: 12)
    let labelsStackView         = UIStackView()
    let buttonStackView         = UIStackView()
    private var like = 0
    private var view = 0
    private var comment = 0
    weak var detailsDelegate: DetailsAction?
    
    let replyBtn        : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(Images.comment, for: .normal)
        return btn
    }()
    
    let retweetBtn        : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(Images.retweet, for: .normal)
        return btn
    }()
    
    let likeBtn        : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(Images.like, for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(with data: Feed) {
        locationLabel.text = data.location
        
        mainImageViewArea.downloadImage(from: data.mainImage)
        imageViewAreaTwo.downloadImage(from: data.otherImages[0])
        imageViewAreaThree.downloadImage(from: data.otherImages[1])
        imageViewAreaFour.downloadImage(from: data.otherImages[2])
        titleLabel.text = data.postTitle
        messageDescriptionLabel.text = data.postDescription
        likesCounter.text = "\(data.likes)"
        commentsCounter.text = "\(data.comments)"
        viewsCounter.text = "\(data.views)"
        
    }
    
    private func configure() {
        likesLabel.text = "Likes: "
        commentsLabel.text = "Comments: "
        viewsLabel.text = "Views: "
        self.addBottomBorderWithColor(color: CustomColors.CustomGreen, width: 1, alpha: 0.7)
        
        //MEDIA VIEW AREA
        let mediaViews = [mainImageViewArea, imageViewAreaTwo, imageViewAreaThree, imageViewAreaFour]
        for imageView in mediaViews {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.backgroundColor = .lightGray
            imageView.applyCustomShadow()
            imageView.clipsToBounds = true
            addSubview(imageView)
        }
        
        
        //LABELS
        let labels = [titleLabel, locationLabel, viewsLabel, viewsCounter, messageDescriptionLabel, likesLabel, likesCounter, commentsLabel, commentsCounter]
        for label in labels {
            addSubview(label)
        }
        viewsCounter.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        commentsCounter.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        likesCounter.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        messageDescriptionLabel.numberOfLines = 5
        messageDescriptionLabel.lineBreakMode = .byTruncatingTail
        setupActionButtons()
        setupConstraints()
        contentView.isUserInteractionEnabled = false
    }
    
    fileprivate func setupActionButtons() {
        let actionButtons = [retweetBtn, replyBtn, likeBtn]
        for button in actionButtons {
            button.tintColor = CustomColors.CustomGreen
            buttonStackView.addArrangedSubview(button)
            button.addTopBorderWithColor(color: .blue, width: 2, alpha: 0.5)
        }
        likeBtn.addTarget(self, action: #selector(liked), for: .touchUpInside)
        replyBtn.addTarget(self, action: #selector(commented), for: .touchUpInside)
        retweetBtn.addTarget(self, action: #selector(shared), for: .touchUpInside)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .fillEqually
        buttonStackView.addTopBorderWithColor(color: .blue, width: 2, alpha: 0.5)
        
        addSubview(buttonStackView)
    }
    
    @objc private func shared(){
        if let val = viewsCounter.text {
            view = Int(val) ?? 0
        }
        if retweetBtn.currentTitleColor != UIColor.systemRed {
            view += 1
            retweetBtn.tintColor = .systemRed
            retweetBtn.setImage(Images.retweeted, for: .normal)
        } else {
            view -= 1
            retweetBtn.setImage(Images.retweet, for: .normal)
            retweetBtn.tintColor = CustomColors.CustomGreen
        }
        viewsCounter.text = "\(view)"
    }
   
    @objc private func liked(){
        if let val = likesCounter.text {
            like = Int(val) ?? 0
        }
        if likeBtn.currentTitleColor != UIColor.systemRed {
            like += 1
            likeBtn.tintColor = .systemRed
            likeBtn.setImage(Images.liked, for: .normal)
        } else {
            like -= 1
            likeBtn.setImage(Images.like, for: .normal)
            likeBtn.tintColor = CustomColors.CustomGreen
        }
        likesCounter.text = "\(like)"
    }
    
    @objc private func commented(_ sender: UIButton){
        if let val = commentsCounter.text {
            comment = Int(val) ?? 0
        }
        if replyBtn.currentTitleColor != UIColor.systemRed {
            comment += 1
            replyBtn.tintColor = .systemRed
            self.detailsDelegate?.detailsAction()
            replyBtn.setImage(Images.commented, for: .normal)
        } else {
            self.detailsDelegate?.detailsAction()
            comment += 1
        }
        commentsCounter.text = "\(comment)"
    }
    
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        let bottomPadding: CGFloat = 20
        let textHeight: CGFloat = 15
        let textWidth: CGFloat = 30
        let mediaHeight: CGFloat = contentView.frame.height / 3
        let mediaWidth: CGFloat = contentView.frame.width / 3.1
        
        //ProfileImage
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        //MediaViewArea
        NSLayoutConstraint.activate([
            mainImageViewArea.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            mainImageViewArea.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            mainImageViewArea.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            mainImageViewArea.heightAnchor.constraint(equalToConstant: mediaHeight)
        ])
        //MediaViewArea 2
        NSLayoutConstraint.activate([
            imageViewAreaTwo.topAnchor.constraint(equalTo: mainImageViewArea.bottomAnchor, constant: padding),
            imageViewAreaTwo.trailingAnchor.constraint(equalTo: imageViewAreaThree.leadingAnchor, constant: -5),
            imageViewAreaTwo.widthAnchor.constraint(equalToConstant: mediaWidth),
            imageViewAreaTwo.heightAnchor.constraint(equalToConstant: mediaHeight * 0.5)
        ])
        //MediaViewArea 3
        
        NSLayoutConstraint.activate([
            imageViewAreaThree.topAnchor.constraint(equalTo: mainImageViewArea.bottomAnchor, constant: padding),
            imageViewAreaThree.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageViewAreaThree.widthAnchor.constraint(equalToConstant: mediaWidth),
            imageViewAreaThree.heightAnchor.constraint(equalToConstant: mediaHeight * 0.5)
        ])
        
        NSLayoutConstraint.activate([
            imageViewAreaFour.topAnchor.constraint(equalTo: mainImageViewArea.bottomAnchor, constant: padding),
            imageViewAreaFour.leadingAnchor.constraint(equalTo: imageViewAreaThree.trailingAnchor, constant: 5),
            imageViewAreaFour.widthAnchor.constraint(equalToConstant: mediaWidth),
            imageViewAreaFour.heightAnchor.constraint(equalToConstant: mediaHeight * 0.5)
        ])
        
        //ActionButtons
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: imageViewAreaFour.bottomAnchor, constant: padding * 2),
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            buttonStackView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        //Title Label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: padding * 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
        ])
        
        //User name Label
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
        ])
        
        //Description Label
        NSLayoutConstraint.activate([
            messageDescriptionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: padding),
            messageDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            messageDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
        ])
        
        //likes Label
        NSLayoutConstraint.activate([
            likesLabel.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            likesLabel.trailingAnchor.constraint(equalTo: likesCounter.leadingAnchor, constant: -2),
        ])
        
        //Likes Counter
        NSLayoutConstraint.activate([
            likesCounter.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            likesCounter.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -textWidth),
            likesCounter.widthAnchor.constraint(equalToConstant: textWidth),
            likesCounter.heightAnchor.constraint(equalToConstant: textHeight)
        ])
        
        //comments Label
        NSLayoutConstraint.activate([
            commentsLabel.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            commentsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -padding),
        ])
        
        //Comments Counter
        NSLayoutConstraint.activate([
            commentsCounter.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            commentsCounter.leadingAnchor.constraint(equalTo: commentsLabel.trailingAnchor, constant: 2),
            commentsCounter.widthAnchor.constraint(equalToConstant: textWidth),
            commentsCounter.heightAnchor.constraint(equalToConstant: textHeight)
        ])
        
        //Views Label
        NSLayoutConstraint.activate([
            viewsLabel.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            viewsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: textWidth),
        ])
        
        //Views Counter
        NSLayoutConstraint.activate([
            viewsCounter.topAnchor.constraint(equalTo: messageDescriptionLabel.bottomAnchor, constant: padding),
            viewsCounter.leadingAnchor.constraint(equalTo: viewsLabel.trailingAnchor, constant: 2),
            viewsCounter.widthAnchor.constraint(equalToConstant: textWidth),
            viewsCounter.heightAnchor.constraint(equalToConstant: textHeight)
        ])
    }
}

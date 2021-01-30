//
//  BackupCells.swift
//  Content
//
//  Created by Leandro Diaz on 1/28/21.
//

import Foundation
/*
static let reuseID          = "PostFeedCell"
let userProfileImage        = CustomAvatarImage(frame: .zero)
let mainImageViewArea       = CustomAvatarImage(frame: .zero)
let imageViewAreaTwo        = CustomAvatarImage(frame: .zero)
let imageViewAreaThree      = CustomAvatarImage(frame: .zero)
let menuButton              = CustomMenuButton()
let userNameLabel           = CustomTitleLabel(title: "", textAlignment: .left, fontSize: 16)
let statusLabel             = CustomSubtitleLabel(fontSize: 14, backgroundColor: .clear)
let postedLabel             = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 12)
let titleLabel              = CustomSecondaryTitleLabel(fontSize: 15, textColor: .label)
let locationLabel           = CustomSecondaryTitleLabel(fontSize: 12, textColor: .systemGray)
let messageDescriptionLabel = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 11)
let likesLabel              = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 10)
let commentsLabel           = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 10)
let viewsLabel              = CustomBodyLabel(textAlignment: .right, backgroundColor: .clear, fontSize: 10)
let labelsStackView         = UIStackView()
let buttonStackView         = UIStackView()

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

func setCell(with data: User) {
    if data.profileImage.isEmpty {
        userProfileImage.image = UIImage(named: Images.Avatar)
    }
    userProfileImage.image =  UIImage(named: data.profileImage)
    userNameLabel.text = data.name
    locationLabel.text = data.location
    
    
    //FEEDS
    for feed in data.feed! {
        mainImageViewArea.downloadImage(from: feed.mainImage) //= UIImage(named: with.media)
        statusLabel.text = feed.status
        postedLabel.text = String(feed.postedOn.timeIntervalSinceNow)
        titleLabel.text = feed.postTitle
        messageDescriptionLabel.text = feed.messageDescription
        likesLabel.text = feed.likes
        commentsLabel.text = feed.comments
        viewsLabel.text = feed.views
    }
}

private func configure() {
    self.addBottomBorderWithColor(color: CustomColors.CustomGreen, width: 1, alpha: 0.7)
    //PROFILE PICTURE
    addSubview(userProfileImage)
    //        profileView.translatesAutoresizingMaskIntoConstraints = false
    
    //MENU BUTTON
    //        menuButton.translatesAutoresizingMaskIntoConstraints = false
    addSubview(menuButton)
    
    //MEDIA VIEW AREA
    let mediaViews = [mainImageViewArea, imageViewAreaTwo, imageViewAreaThree]
    for imageView in mediaViews {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        imageView.applyCustomShadow()
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
    
    //LABELS
    let labels = [userNameLabel, statusLabel, postedLabel, titleLabel, locationLabel, viewsLabel, messageDescriptionLabel, likesLabel, commentsLabel]
    for label in labels {
        addSubview(label)
    }
    messageDescriptionLabel.numberOfLines = 5
    messageDescriptionLabel.lineBreakMode = .byTruncatingTail
    
    setupActionButtons()
    setupConstraints()
}

fileprivate func setupActionButtons() {
    let actionButtons = [replyBtn, retweetBtn, likeBtn]
    for button in actionButtons {
        button.tintColor = CustomColors.CustomGreen
        buttonStackView.addArrangedSubview(button)
        button.addTopBorderWithColor(color: .blue, width: 2, alpha: 0.5)
    }
    buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    buttonStackView.distribution = .fillEqually
    buttonStackView.addTopBorderWithColor(color: .blue, width: 2, alpha: 0.5)
    
    addSubview(buttonStackView)
}

private func setupConstraints() {
    let padding: CGFloat = 10
    let bottomPadding: CGFloat = 20
    let mediaHeight: CGFloat = contentView.frame.height / 3
    let mediaWidth: CGFloat = contentView.frame.width / 2.05
    
    //ProfileImage
    NSLayoutConstraint.activate([
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        
        userProfileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
        userProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
        userProfileImage.widthAnchor.constraint(equalToConstant: 40),
        userProfileImage.heightAnchor.constraint(equalToConstant: 40)
    ])
    
    //User name Label
    NSLayoutConstraint.activate([
        userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
        userNameLabel.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: padding),
    ])
    
    //status Label
    NSLayoutConstraint.activate([
        postedLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
        postedLabel.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: padding),
    ])
    
    //status Label
    NSLayoutConstraint.activate([
        statusLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
        statusLabel.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: padding),
    ])
    
    //Menu Button
    NSLayoutConstraint.activate([
        menuButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
        menuButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
    ])
    
    //MediaViewArea
    NSLayoutConstraint.activate([
        mainImageViewArea.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: padding),
        mainImageViewArea.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
        mainImageViewArea.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        mainImageViewArea.heightAnchor.constraint(equalToConstant: mediaHeight)
    ])
    //MediaViewArea 2
    NSLayoutConstraint.activate([
        imageViewAreaTwo.topAnchor.constraint(equalTo: mainImageViewArea.bottomAnchor, constant: padding),
        imageViewAreaTwo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
        imageViewAreaTwo.widthAnchor.constraint(equalToConstant: mediaWidth),
        imageViewAreaTwo.heightAnchor.constraint(equalToConstant: mediaHeight * 0.8)
    ])
    //MediaViewArea 3
    
    NSLayoutConstraint.activate([
        imageViewAreaThree.topAnchor.constraint(equalTo: mainImageViewArea.bottomAnchor, constant: padding),
        imageViewAreaThree.leadingAnchor.constraint(equalTo: imageViewAreaTwo.trailingAnchor, constant: padding),
        imageViewAreaThree.widthAnchor.constraint(equalToConstant: mediaWidth),
        imageViewAreaThree.heightAnchor.constraint(equalToConstant: mediaHeight * 0.8)
    ])
    
    //Title Label
    NSLayoutConstraint.activate([
        titleLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -padding),
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
    ])
    
    //User name Label
    NSLayoutConstraint.activate([
        locationLabel.bottomAnchor.constraint(equalTo: messageDescriptionLabel.topAnchor, constant: -padding),
        locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
    ])
    
    //Description Label
    NSLayoutConstraint.activate([
        messageDescriptionLabel.bottomAnchor.constraint(equalTo: likesLabel.topAnchor, constant: -padding),
        messageDescriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
        messageDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
    ])
    
    //likes Label
    NSLayoutConstraint.activate([
        likesLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -bottomPadding),
        likesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
    ])
    
    //comments Label
    NSLayoutConstraint.activate([
        commentsLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -bottomPadding),
        commentsLabel.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: padding),
    ])
    
    //Views Label
    NSLayoutConstraint.activate([
        viewsLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -bottomPadding),
        viewsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
    ])
    
    //ActionButtons
    NSLayoutConstraint.activate([
        buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
        buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
        buttonStackView.heightAnchor.constraint(equalToConstant: 30),
        buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
    ])
}
*/


//MARK:- POST VIEW CONTROLLER
/*class PostViewController: UIViewController, UITextFieldDelegate {
 
 enum Section {
     case main
     case feeds
 }
 
 let firestore = FireStoreManager.shared
 
 let sections = Section.self
 var collectionView: UICollectionView!
 var dataSource: UICollectionViewDiffableDataSource<Section, User>!
//    var feeds = testingFeed
 var feedReference = [User]()
 var feeds = testingData
 
 
 override func viewDidLoad() {
     super.viewDidLoad()
     configureNavigationBar()
     configureCollectionView()
     registerCell()
     configureDataSource()
//        firestore.configure()
     reloadData(with: feeds)
//        firestore.configure()
     print(firestore)
     
   getFeedsFromServer()
     
 }
 
 func getFeedsFromServer() {
     
     firestore.getFeeds { (receivedFeeds) in
//            print(receivedFeeds)
//            guard let dataReceived = receivedFeeds else { return }
//            print("received feeds on postVC: ", dataReceived)
//
//            dataReceived.forEach{
//                let receivedFeed = $0
////                for feed in receivedFeed! {
//
//
////                let receivedPost = User(dictionary: $0.userDictionary)
//
//                self.feedReference.append(receivedFeed)
//                for feed in receivedFeed.feed! {
//                self.feeds.append(feed)
//                }
//
////                }
//            }
//
//            DispatchQueue.main.async {
//
//                self.reloadData(with: self.feeds)
//            }
         
//            self.feeds.append(dataReceived)
         
         
     }
//        firestore.getFeeds { [weak self ](receivedFeeds) in
//            guard let self = self else { return }
//            guard let receivedFeeds = receivedFeeds else { return }
//            print("received feeds on postVC: ", receivedFeeds)
//            self.feedReference.append(contentsOf: receivedFeeds)
//            print(self.feedReference)
//            self.reloadData(with: self.feedReference)
//        }
//        print(feedReference)
 }
 
 private func configureNavigationBar() {
//        let titleImageView = UIImageView(image: Images.like)
//        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//        titleImageView.contentMode = .scaleAspectFit
//        titleImageView.tintColor = .blue
//        navigationItem.titleView = titleImageView
     
     let newPost = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPost))
     navigationItem.rightBarButtonItem = newPost
 }
 
 @objc func addNewPost() {
     print("New post")
     let postVC = CreateNewPostViewController()
     let navController = UINavigationController(rootViewController: postVC)
     self.navigationController?.present(navController, animated: true, completion: nil)
 }
 
 
 
 private func configureCollectionView() {
     let layuout = configureLayout()
     collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layuout)
     collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
     collectionView.sizeToFit()
     collectionView.backgroundColor = .systemBackground
     view.addSubview(collectionView)
 }
 
 private func registerCell(){
     collectionView.register(PostsFeedCell.self, forCellWithReuseIdentifier: PostsFeedCell.reuseID)
 }
 
 private func configureDataSource() {
     dataSource = UICollectionViewDiffableDataSource<Section, User>(collectionView: collectionView) { (collectionView, indexPath, feed) -> UICollectionViewCell? in
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostsFeedCell.reuseID, for: indexPath) as? PostsFeedCell else {
             fatalError("can't deque cell")
         }
         
         cell.setCell(with: feed)
         return cell
     }
 }
 
 fileprivate func reloadData(with feed: [User]) {
     var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
     
     if feed.isEmpty {
         self.showEmptyState(with: "Nothing to show here yet, Create some posts...", in: self.view)
     } else {
     
     snapshot.appendSections([.main])
     snapshot.appendItems(feed)
     DispatchQueue.main.async {
         self.dataSource.apply(snapshot, animatingDifferences: false)
     }
     }
 }
 
 private func configureLayout() -> UICollectionViewLayout {
     let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
     let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 5, bottom: 5, trailing: 5)
    
     
     let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.96), heightDimension: .fractionalHeight(0.8))
     let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
     group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
     group.interItemSpacing = .flexible(15)
    
     let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 15
//        section.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 5, bottom: 5, trailing: 5)
     section.orthogonalScrollingBehavior = .groupPagingCentered
     let layout = UICollectionViewCompositionalLayout(section: section)
     return layout
 }

}

*/

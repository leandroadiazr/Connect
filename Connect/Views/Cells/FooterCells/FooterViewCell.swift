//
//  FooterViewCell.swift
//  Content
//
//  Created by Leandro Diaz on 1/14/21.
//

import UIKit

class FooterViewCell: UICollectionViewCell {
    static let reuseID = "FooterViewCell"
    
    let titleLabel  = UILabel()
    let detailsLabel = UILabel()
    let viewImage   = UIImageView()
    let whiteBackgroundView = UIView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeaderCell(with: String) {
        
        //        titleLabel.text = movies.title
        //        detailsLabel.text = movies.year
        //        viewImage.downloadImage(from: movies.poster)
    }
    
    private func configure() {
        
        whiteBackgroundView.backgroundColor = .systemBackground
        whiteBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(whiteBackgroundView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Show More....."
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.textColor = CustomColors.CustomGreen
        addSubview(titleLabel)
        
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(detailsLabel)
//
//
//        addSubview(viewImage)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            
//            viewImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//            //            viewImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            viewImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
//            viewImage.widthAnchor.constraint(equalToConstant: 70),
//            viewImage.heightAnchor.constraint(equalToConstant: 70),
            
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            whiteBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            whiteBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            whiteBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            whiteBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
            
//            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
//            detailsLabel.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor, constant: padding),
//            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
        
    }
}

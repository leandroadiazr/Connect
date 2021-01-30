//
//  HeaderViewCell.swift
//  Content
//
//  Created by Leandro Diaz on 1/14/21.
//

import UIKit

class HeaderViewCell: UICollectionViewCell {
    static let reuseID = "HeaderViewCell"
    
    let titleLabel  = CustomTitleLabel()
    let detailsLabel = UILabel()
    let viewImage   = UIImageView()
    
    
    
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
        backgroundColor = .systemBackground
        addBottomBorderWithColor(color: CustomColors.SeparatorColor, width: 0.3, alpha: 0.7)
        
        titleLabel.text = "FOLLOWING....."
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
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
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
//            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            
            //            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            //            detailsLabel.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor, constant: padding),
            //            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
        
    }
}

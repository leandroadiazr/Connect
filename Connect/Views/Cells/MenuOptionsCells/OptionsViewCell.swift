//
//  OptionsViewCell.swift
//  Connect
//
//  Created by Leandro Diaz on 2/3/21.
//

import UIKit

class OptionsViewCell: UITableViewCell {

    static let reuseID = "OptionsViewCell"
    let titleLabel  = CustomTitleLabel()
    let detailsLabel = CustomBodyLabel(textAlignment: .left, backgroundColor: .clear, fontSize: 11)
    let viewImage   = GenericImageView(frame: .zero)
     
    var settings: Options?
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         configure()
        
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with: Options) {
        titleLabel.text = with.titleLabel
        detailsLabel.text = with.detailsLabel
        viewImage.image = with.viewImage
    }
    
    private func configure() {
        backgroundColor = randomColor()
        sizeToFit()
        let labels = [titleLabel, detailsLabel]
        for label in labels {
            label.textColor = .white
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            addSubview(label)
        }
        
        
        viewImage.tintColor = .white
        viewImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(viewImage)
        
       setupConstraints()
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 5
        
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            viewImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            viewImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            viewImage.widthAnchor.constraint(equalToConstant: 30),
            viewImage.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: padding * 2),
            titleLabel.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            detailsLabel.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor, constant: padding ),
            detailsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding)
        ])
               
    }

}

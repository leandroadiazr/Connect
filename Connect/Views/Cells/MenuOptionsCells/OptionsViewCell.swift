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
     let viewImage   = UIImageView()
     
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
        viewImage.image = with.viewImage
    }
    
    private func configure() {
        backgroundColor = randomColor()
        layer.cornerRadius = 10
        viewImage.tintColor = .white
        titleLabel.textColor = .white
        sizeToFit()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        viewImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(viewImage)
        
       setupConstraints()
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            viewImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            viewImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            viewImage.widthAnchor.constraint(equalToConstant: 30),
            viewImage.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: viewImage.trailingAnchor, constant: padding + 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
               
    }

}

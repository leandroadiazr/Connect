//
//  CustomNavCon.swift
//  Ecommerce
//
//  Created by Leandro Diaz on 1/11/21.
//

import UIKit

class CustomNavCon: UINavigationController {

    var tintColor: UIColor?
    var backgroundColor: UIColor?
    var translucent: Bool?
    var largeTitles: Bool?
    
    var mainTitle = UILabel()
    var leftImage = GenericImageView(frame: .zero)
    
    
    
    init(rootViewController: UIViewController, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil){
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = [rootViewController]
        configure()
    }
    
    convenience init(rootViewController: UIViewController, tintColor: UIColor, translucent: Bool, largeTitles: Bool, title: String) {
        self.init(rootViewController: rootViewController)
        self.navigationBar.barTintColor = tintColor
        self.navigationBar.isTranslucent = translucent
        self.navigationBar.prefersLargeTitles = largeTitles
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func configure() {
//        setupConstraints()
    }

    private func setupConstraints() {
        let padding: CGFloat = 20
        
        //Main Title
        NSLayoutConstraint.activate([
            mainTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainTitle.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
        ])
            
    }
}

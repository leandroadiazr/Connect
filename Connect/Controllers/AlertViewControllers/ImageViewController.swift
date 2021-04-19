//
//  ImageViewController.swift
//  Connect
//
//  Created by Leandro Diaz on 4/18/21.
//

import UIKit

class ImageViewController: UIViewController {
    
    let containerview = AlertContainerView()
    let zoomedImageView = GenericImageView(frame: .zero)
    let closeBtn        = CustomMainButton(backgroundColor: .clear, title: "", textColor: .systemRed, borderWidth: 1, borderColor: UIColor.systemRed.cgColor, buttonImage: Images.close)
    var zoomedImage: String?
    
    init(zoomedImage: String){
        super.init(nibName: nil, bundle: nil)
        self.zoomedImage = zoomedImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureImageView()
        setupConstraints()
        setupCloseButtonAction()
    }
    
    private func setupCloseButtonAction() {
        closeBtn.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    func configureContainerView(){
        view.addSubview(containerview)
        view.addSubview(closeBtn)
        closeBtn.tintColor = .systemRed
    }
    
    func configureImageView(){
        zoomedImageView.downloadImage(from: zoomedImage ?? "")
        zoomedImageView.layer.cornerRadius = 16
        containerview.addSubview(zoomedImageView)
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
     
    private func setupConstraints(){
        let padding: CGFloat = 1
        //Container View Constraints
        NSLayoutConstraint.activate([
            containerview.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerview.widthAnchor.constraint(equalToConstant: 340),
            containerview.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        NSLayoutConstraint.activate([
            closeBtn.centerYAnchor.constraint(equalTo: containerview.topAnchor),
            closeBtn.centerXAnchor.constraint(equalTo: containerview.trailingAnchor),
            closeBtn.widthAnchor.constraint(equalToConstant: 30),
            closeBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        //ImageView
        NSLayoutConstraint.activate([
            zoomedImageView.topAnchor.constraint(equalTo: containerview.topAnchor, constant: padding),
            zoomedImageView.leadingAnchor.constraint(equalTo: containerview.leadingAnchor, constant: padding),
            zoomedImageView.trailingAnchor.constraint(equalTo: containerview.trailingAnchor, constant: -padding),
            zoomedImageView.bottomAnchor.constraint(equalTo: containerview.bottomAnchor, constant: -padding)
        ])
    }
}



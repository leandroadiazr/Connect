//
//  GenericImageView.swift
//  Connect
//
//  Created by Leandro Diaz on 2/7/21.
//

import UIKit

class GenericImageView: UIImageView {
    let cache = FireStorageManager.shared.cache
    let placeHolderImage = Images.Empty
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        clipsToBounds       = true
        layer.cornerRadius  = 5
        layer.borderWidth   = 1
        layer.borderColor   = UIColor.tertiaryLabel.cgColor
        image               = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(from urlString: String) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            guard let self = self else { return }
            if error != nil { return }
            guard let result = response as? HTTPURLResponse, result.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}

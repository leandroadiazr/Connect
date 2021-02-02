//
//  ImageCache.swift
//  Connect
//
//  Created by Leandro Diaz on 2/1/21.
//

import UIKit


class ImageCache: NSCache<NSString, AnyObject > {
    
    
    func getImage(named imageName: String, completion: @escaping (UIImage?) -> Void) {
        if let image = object(forKey: imageName as NSString) as? UIImage{
            completion(image)
        } else {
            let url = URL(string: imageName)!
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                setValue(image, forKey: imageName)
                completion(image)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
}

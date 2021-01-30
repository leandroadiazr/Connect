//
//  FireStorageManager.swift
//  Content
//
//  Created by Leandro Diaz on 1/26/21.
//

import UIKit
import FirebaseStorage

class FireStorageManager {
    private init() {}
    static let shared = FireStorageManager()
    private let storage = Storage.storage()
    private lazy var imagesReferences = storage.reference().child("images")
    
    
    func uploadData(_ image: UIImage, completion: @escaping (String) -> Void) {
        let imageRef = imagesReferences.child("images/\(UUID().uuidString).jpg")
        
        //convert image to data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        imageRef.putData(imageData, metadata: nil) { (_, error) in
            if let unwrappedError = error {
                print("unwrappedError :", unwrappedError)
            } else {
                imageRef.downloadURL { (url, downloadError) in
                    if let unwrappedDownloadError = downloadError {
                        print(unwrappedDownloadError)
                        
                    } else if let unwrappedUrl = url {
                        completion(unwrappedUrl.absoluteString)
                    }
                
                }
            }
        }
    }
    
    func bulkUpload(_ images: [UIImage], completion: @escaping  ([String]) -> Void) {
        let semaphore = DispatchSemaphore(value: images.count)
        
        var imagesPaths = [String]()
        var counter = 0
        for image in images {
            semaphore.wait()
            uploadData(image) { (urlPath) in
                    
                imagesPaths.append(urlPath)
                counter += 1
                if counter == images.count {
                    completion(imagesPaths)
                }
                semaphore.signal()
            }
        }
        
       
    }
}

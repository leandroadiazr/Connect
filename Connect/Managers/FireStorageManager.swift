//
//  FireStorageManager.swift
//  Content
//
//  Created by Leandro Diaz on 1/26/21.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class FireStorageManager {
    private init() {}
    static let shared = FireStorageManager()
    private let storage = Storage.storage()
    private let firestore = FireStoreManager.shared
    private lazy var imagesReferences = storage.reference().child("images")
    
    
    
    func uploadProfileImage(user: User, completion: @escaping (Result<String, ErrorMessages>) -> Void) {
        let changeProfile = Auth.auth().currentUser?.createProfileChangeRequest()
        changeProfile?.displayName = user.name
        let imageURL = URL(fileURLWithPath: user.profileImage)
        changeProfile?.photoURL = imageURL
        changeProfile?.commitChanges(completion: { (error) in
            if let unwrappedError = error {
                completion(.failure(.unableToSaveProfile))
            } else {
                guard let userID = Auth.auth().currentUser?.uid else { return }
                self.firestore.saveUser(user: user, userID: userID) { (error) in
                    completion(.success("Profile Saved"))
                }
                
                completion(.success("Profile Saved"))
            }
        })
    }
    
    
    func uploadSingleImage(_ image: UIImage, completion: @escaping (String) -> Void) {
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
            uploadSingleImage(image) { (urlPath) in
                    
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

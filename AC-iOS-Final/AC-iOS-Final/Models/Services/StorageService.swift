//
//  StorageService.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit
import Toucan
import FirebaseStorage

class StorageService {
    init() {
        self.ref = Storage.storage().reference()
        self.imageRef = self.ref.child("images")
    }
    private let ref: StorageReference!
    private let imageRef: StorageReference!
    
    public func storeImage(withPostID postID: String, andImage image: UIImage, completion: @escaping (URL?, ErrorMessage?) -> Void) {
        //resize image
        guard let toucanImage = Toucan(image: image).resize(CGSize(width: 500, height: 500)).image else {
            print("could not resize image")
            completion(nil, "could not resize image")
            return
        }
        
        //convert image to png data
        guard let imageData = UIImagePNGRepresentation(toucanImage) else {
            print("couldn't get png image data")
            completion(nil, "couldn't get png image data")
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        imageRef.child(postID).putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("could not store image: \(error.localizedDescription)")
                completion(nil, "could not store image: \(error.localizedDescription)")
            } else if let metadata = metadata {
                let imageDownloadURL = metadata.downloadURL()
                completion(imageDownloadURL, nil)
            }
        }
    }
}

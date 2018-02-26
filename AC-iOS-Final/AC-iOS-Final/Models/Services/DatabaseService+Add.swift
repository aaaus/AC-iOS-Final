//
//  DatabaseService+Add.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

extension DatabaseService {
    public func addPost(_ post: Post, andImage image: UIImage) {
        var storePost = post
        let ref = postsRef.childByAutoId()
        
        //store image first
        StorageService().storeImage(withPostID: ref.key, andImage: image, completion: { (imageURL, errorMessage) in
            if let imageURL = imageURL {
                storePost.imageURL = imageURL
                guard let postData = storePost.toJSON() else {
                    print("Error: Could not turn post to json.")
                    self.delegate?.didFailAddPost?(errorMessage: "Could not turn post to json.")
                    return
                }
                //then add post with image URL
                ref.setValue(postData) {(error, _) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        self.delegate?.didFailAddPost?(errorMessage: error.localizedDescription)
                    } else {
                        self.delegate?.didAddPost?()
                        print("Success: Added post \(ref.key)")
                    }
                }
            } else if let errorMessage = errorMessage {
                print("Error: Could not store image!\n\(errorMessage)")
                self.delegate?.didFailAddPost?(errorMessage: errorMessage)
            }
        })
    }
}

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
        let ref = postsRef.childByAutoId()
        guard let postData = post.toJSON() else {
            print("Error: Could not turn post to json.")
            delegate?.didFailAddPost?(errorMessage: "Could not turn post to json.")
            return
        }
        ref.setValue(postData) { (error, _) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.delegate?.didFailAddPost?(errorMessage: error.localizedDescription)
            } else {
                self.delegate?.didAddPost?()
                //store image!!
                print("Success: Added post \(ref.key)")
            }
        }
    }
}

//
//  DatabaseService+Get.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DatabaseService {
    public func getPosts(completion: @escaping ([Post]?) -> Void) {
        postsRef.observe(.value) { (dataSnapshot) in
            guard let postsSnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else {
                print("Error: Could not get children datasnapshots.")
                self.delegate?.didFailGettingPosts?(errorMessage: "Could not get children datasnapshots.")
                completion(nil)
                return
            }
            var posts: [Post] = []
            for postSnapshot in postsSnapshot {
                guard let postDict = postSnapshot.value as? [String : Any] else {
                    print("Error: Could not initialize postDict from postSnapshot.")
                    self.delegate?.didFailGettingPosts?(errorMessage: "Could not initialize postDict from postSnapshot.")
                    completion(nil)
                    return
                }
                guard let post = Post(from: postDict) else {
                    print("Error: Could not instantiate post from postDict.")
                    self.delegate?.didFailGettingPosts?(errorMessage: "Could not instantiate post from postDict.")
                    completion(nil)
                    return
                }
                posts.append(post)
            }
            completion(posts)
        }
    }
}

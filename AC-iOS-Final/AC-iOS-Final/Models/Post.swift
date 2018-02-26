//
//  Post.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation

struct Post: Codable {
    let userID : String
    let postID: String
    let comment: String
    
    init?(from postDict: [String : Any]) {
        guard let userID = postDict["userID"] as? String else {
            print("couldn't get userID from postDict")
            return nil
        }
        guard let postID = postDict["postID"] as? String else {
            print("couldn't get postID from postDict")
            return nil
        }
        guard let comment = postDict["comment"] as? String else {
            print("couldn't get comment from postDict")
            return nil
        }
        
        self.userID = userID
        self.postID = postID
        self.comment = comment
    }
    
    public func toJSON() -> Any? {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(self)
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            return jsonData
        } catch {
            print("error: could not encode data\n\(error)")
        }
        return nil
    }
}

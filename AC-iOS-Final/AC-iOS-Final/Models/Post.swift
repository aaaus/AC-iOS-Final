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
    let comment: String
    var imageURL: URL?
    
    init(userID: String, comment: String) {
        self.userID = userID
        self.comment = comment
    }
    
    init?(from postDict: [String : Any]) {
        guard let userID = postDict["userID"] as? String else {
            print("couldn't get userID from postDict")
            return nil
        }
        guard let comment = postDict["comment"] as? String else {
            print("couldn't get comment from postDict")
            return nil
        }
        let imageURL = postDict["imageURL"] as? URL
        
        self.userID = userID
        self.comment = comment
        self.imageURL = imageURL
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

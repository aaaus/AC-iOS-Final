//
//  DatabaseService.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseService {
    init() {
        self.ref = Database.database().reference()
        self.postRef = self.ref.child("posts")
    }
    
    private let ref: DatabaseReference!
    public let postRef: DatabaseReference!
    public weak var delegate: DatabaseServiceDelegate?
}

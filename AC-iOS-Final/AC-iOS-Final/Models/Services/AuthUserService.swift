//
//  AuthUserService.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation
import FirebaseAuth

protocol AuthUserServiceDelegate: class {
    //to do
}

typealias DidSignOut = Bool

class AuthUserService {
    private init() {
        self.auth = Auth.auth()
    }
    static let manager = AuthUserService()
    private let auth: Auth!
    public weak var delegate: AuthUserServiceDelegate?
    
    public func createAccount(withEmail email: String, andPassword password: String, completion: @escaping (User?, Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(nil, error)
            } else if let user = user {
                completion(user, nil)
            }
        }
    }
    
    public func signIn(withEmail email: String, andPassword password: String, completion: @escaping (User?, Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("couldn't sign in!")
                completion(nil, error)
            } else if let user = user {
                print("signed in!!!!!")
                completion(user, nil)
            }
        }
    }
    
    public func getCurrentUser() -> User? {
        return auth.currentUser
    }
    
    public func signOut(completion: @escaping (DidSignOut) -> Void) {
        do {
            try auth.signOut()
            print("did sign out")
            completion(true)
        } catch {
            print("did fail sign out: \(error.localizedDescription)")
            completion(false)
        }
    }
}

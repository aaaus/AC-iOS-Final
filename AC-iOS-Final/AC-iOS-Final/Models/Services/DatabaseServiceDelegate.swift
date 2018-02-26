//
//  DatabaseServiceDelegate.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation

typealias ErrorMessage = String

@objc protocol DatabaseServiceDelegate: class {
    @objc optional func didAddPost()
    @objc optional func didFailAddPost(errorMessage: ErrorMessage)
//    @objc optional func didStoreImage() //use this for adding post completion
    @objc optional func didFailStoringImage(errorMessage: ErrorMessage)
    @objc optional func didFailGettingPosts(errorMessage: ErrorMessage)
}

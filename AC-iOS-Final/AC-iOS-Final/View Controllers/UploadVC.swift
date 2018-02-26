//
//  UploadVC.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit
import SVProgressHUD

class UploadVC: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    
    private var currentUserID: String {
        return AuthUserService.manager.getCurrentUser()!.uid
    }
    private let databaseService = DatabaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseService.delegate = self
        setUpGestures()
    }
    
    private func setUpGestures() {
        postImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imagePressed))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(imagePressed))
        postImageView.addGestureRecognizer(tapGesture)
        postImageView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func imagePressed() {
        //to do - set up photo image picker
        print("image pressed!!!")
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //when image set, change the image content mode
        print("add button pressed!!")
        guard let image = postImageView.image, image != #imageLiteral(resourceName: "camera_icon") else {
            let errorAlert = Alert.createErrorAlert(withMessage: "Please pick an image to upload!!!", andCompletion: nil)
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        guard let commentText = postTextView.text, !commentText.isEmpty else {
            let errorAlert = Alert.createErrorAlert(withMessage: "Please enter some text!!!", andCompletion: nil)
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        SVProgressHUD.show()
        let post = Post(userID: currentUserID, comment: commentText)
        databaseService.addPost(post, andImage: image)
    }
    
    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        postImageView.image = #imageLiteral(resourceName: "camera_icon")
        postTextView.text = nil
        self.view.endEditing(true)
        print("everything cleared!!")
    }
}

extension UploadVC: DatabaseServiceDelegate {
    func didAddPost() {
        SVProgressHUD.dismiss()
        let successAlert = Alert.createSuccessAlert(withMessage: "You added the post!!!!!!", andCompletion: { [weak self] _ in
            self?.postImageView.image = #imageLiteral(resourceName: "camera_icon")
            self?.postTextView.text = nil
        })
        self.present(successAlert, animated: true, completion: nil)
    }
    
    func didFailAddPost(errorMessage: ErrorMessage) {
        SVProgressHUD.dismiss()
        let errorAlert = Alert.createErrorAlert(withMessage: "Could not add post:\n\(errorMessage)", andCompletion: nil)
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func didFailStoringImage(errorMessage: ErrorMessage) {
        SVProgressHUD.dismiss()
        let errorAlert = Alert.createErrorAlert(withMessage: "Could not store image:\n\(errorMessage)", andCompletion: nil)
        self.present(errorAlert, animated: true, completion: nil)
    }
}

//
//  UploadVC.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit
import SVProgressHUD
import NotificationCenter
import AVFoundation

class UploadVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    
    private var notificationCenter: NotificationCenter!
    private var keyboardIsShowing: Bool = false
    private var currentUserID: String {
        return AuthUserService.manager.getCurrentUser()!.uid
    }
    private var databaseService: DatabaseService!
    private var imagePickerVC: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseService = DatabaseService()
        databaseService.delegate = self
        imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        setUpViews()
        setUpNotification()
        setUpGestures()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setUpViews() {
        postTextView.layer.masksToBounds = true
        postTextView.layer.cornerRadius = 10
        postTextView.layer.borderWidth = 1.0
        postTextView.layer.borderColor = UIColor.black.cgColor
    }
    
    private func setUpNotification() {
        notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if !keyboardIsShowing {
            return
        }
        print("keyboard will hide")
        guard let keyboardRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            print("couldn't get keyboard height")
            return
        }
        let contentInset = scrollView.adjustedContentInset
        scrollView.contentInsetAdjustmentBehavior = .automatic
        scrollView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, contentInset.bottom - keyboardRect.height, contentInset.right)
        keyboardIsShowing = false
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if keyboardIsShowing {
            return
        }
        print("keyboard will show")
        guard let keyboardRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            print("couldn't get keyboard height")
            return
        }
        let contentInset = scrollView.adjustedContentInset
        scrollView.contentInsetAdjustmentBehavior = .automatic
        scrollView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, contentInset.bottom + keyboardRect.height, contentInset.right)
        scrollView.scrollRectToVisible(postTextView.layer.frame, animated: false)
        keyboardIsShowing = true
    }
    
    private func setUpGestures() {
        postImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imagePressed))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(imagePressed))
        postImageView.addGestureRecognizer(tapGesture)
        postImageView.addGestureRecognizer(longPressGesture)
        
        let scrollViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollView.addGestureRecognizer(scrollViewTapGesture)
    }
    
    @objc func imagePressed() {
        print("image pressed!!!")
        self.view.endEditing(true)
        
        let actionSheet = Alert.createActionSheet(withTitle: "Add Image", andMessage: nil)
        Alert.addAction(withTitle: "Photo Library", style: .default, andCompletion: { [weak self] (_) in
            self?.imagePickerVC.sourceType = .photoLibrary
            self?.checkAVAuthorization()
        }, toAlertController: actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            Alert.addAction(withTitle: "Camera", style: .default, andCompletion: { [weak self] (_) in
                self?.imagePickerVC.sourceType = .camera
                self?.checkAVAuthorization()
            }, toAlertController: actionSheet)
        }
        Alert.addAction(withTitle: "Cancel", style: .cancel, andCompletion: nil, toAlertController: actionSheet)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func scrollViewTapped() {
        self.view.endEditing(true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //when image set, change the image content mode
        self.view.endEditing(true)
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
        postImageView.contentMode = .center
        postImageView.image = #imageLiteral(resourceName: "camera_icon")
        postTextView.text = nil
        self.view.endEditing(true)
        print("everything cleared!!")
    }
    
    private func checkAVAuthorization() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            print("notDetermined")
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                if granted {
                    self.showImagePicker()
                } else {
                    self.deniedPhotoAlert()
                }
            })
        case .denied:
            print("denied")
            deniedPhotoAlert()
        case .authorized:
            print("authorized")
            showImagePicker()
        case .restricted:
            print("restricted")
        }
    }
    
    private func showImagePicker() {
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    private func deniedPhotoAlert() {
        let settingsAlert = Alert.createAlert(withTitle: "Please Allow Photo Access", andMessage: "This will allow you to share photos from your library and your camera.")
        Alert.addAction(withTitle: "Cancel", style: .cancel, andCompletion: nil, toAlertController: settingsAlert)
        Alert.addAction(withTitle: "Settings", style: .default, andCompletion: { (_) in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }, toAlertController: settingsAlert)
        self.present(settingsAlert, animated: true, completion: nil)
    }
}

extension UploadVC: DatabaseServiceDelegate {
    func didAddPost() {
        SVProgressHUD.dismiss()
        let successAlert = Alert.createSuccessAlert(withMessage: "You added the post!!!!!!", andCompletion: { [weak self] _ in
            self?.postImageView.contentMode = .center
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

extension UploadVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("could not get selected image")
            return
        }
        postImageView.contentMode = .scaleAspectFit
        postImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}

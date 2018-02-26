//
//  UploadVC.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class UploadVC: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        postImageView.image = #imageLiteral(resourceName: "camera_icon")
        postTextView.text = nil
        self.view.endEditing(true)
    }
}

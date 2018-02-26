//
//  FeedVC.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        AuthUserService.manager.signOut { [weak self] (didSignOut) in
            if didSignOut {
                let successAlert = Alert.createSuccessAlert(withMessage: "You signed out smh 😒", andCompletion: { (_) in
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                })
                self?.present(successAlert, animated: true, completion: nil)
            } else {
                let errorAlert = Alert.createErrorAlert(withMessage: "Could not sign out... try closing the app and trying again.", andCompletion: nil)
                self?.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
}

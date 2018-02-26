//
//  LoginVC.swift
//  AC-iOS-Final
//
//  Created by C4Q  on 2/22/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction private func loginRegisterButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            let errorAlert = Alert.createErrorAlert(withMessage: "Please enter an email!!", andCompletion: nil)
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        guard let password = passwordTextField.text else {
            let errorAlert = Alert.createErrorAlert(withMessage: "Please enter a password!!", andCompletion: nil)
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
        
        AuthUserService.manager.signIn(withEmail: email, andPassword: password) { [weak self] (_, signInError) in
            if let errorCode = (signInError as NSError?)?.code, let error = AuthErrorCode(rawValue: errorCode) {
                switch error {
                case .userNotFound: //then make new account
                    AuthUserService.manager.createAccount(withEmail: email, andPassword: password, completion: { (_, createError) in
                        if let createError = createError {
                            let errorAlert = Alert.createErrorAlert(withMessage: "Could not create account:\n\(createError.localizedDescription)", andCompletion: nil)
                            self?.present(errorAlert, animated: true, completion: nil)
                        } else {
                            //segue to feed
                            print("sign up and login successful")
                            self?.performSegue(withIdentifier: "feedSegue", sender: self)
                        }
                    })
                    return
                default:
                    let errorAlert = Alert.createErrorAlert(withMessage: "Could not sign in:\n\(signInError!.localizedDescription)", andCompletion: nil)
                    self?.present(errorAlert, animated: true, completion: nil)
                }
            } else { //sign in successful
                //segue to feed
                print("login successful")
                self?.performSegue(withIdentifier: "feedSegue", sender: self)
            }
        }
    }
    
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


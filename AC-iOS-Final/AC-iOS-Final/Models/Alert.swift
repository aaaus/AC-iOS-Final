//
//  Alert.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class Alert {
    public static func createAlert(withTitle title: String?, andMessage message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    public static func createActionSheet(withTitle title: String?, andMessage message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    }
    public static func addAction(withTitle title: String, style: UIAlertActionStyle, andCompletion completion: ((UIAlertAction) -> Void)?, toAlertController alertController: UIAlertController) {
        let alertAction = UIAlertAction(title: title, style: style, handler: completion)
        alertController.addAction(alertAction)
    }
    public static func createErrorAlert(withMessage message: String, andCompletion completion: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let errorAlert = createAlert(withTitle: "Error smh 😒", andMessage: message)
        addAction(withTitle: "Aww man sorry 😭", style: .default, andCompletion: completion, toAlertController: errorAlert)
        return errorAlert
    }
    public static func createSuccessAlert(withMessage message: String, andCompletion completion: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let successAlert = createAlert(withTitle: "Success!!! 🎉", andMessage: message)
        addAction(withTitle: "Lol thanks 😂", style: .default, andCompletion: completion, toAlertController: successAlert)
        return successAlert
    }
}

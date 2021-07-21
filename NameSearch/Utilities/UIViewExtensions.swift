//
//  UIViewExtensions.swift
//  NameSearch
//
//  Created by Leandro Diaz on 7/21/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //Custom Alert
    func showCustomAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

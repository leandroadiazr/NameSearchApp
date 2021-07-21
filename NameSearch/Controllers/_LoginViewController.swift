//
//  _LoginViewController.swift
//  NameSearch
//
//  Created by Leandro Diaz on 7/20/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import UIKit

import UIKit

class _LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    var username: String?
    var password: String?

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard !usernameTextField.text!.isEmpty else {
            print("empty user name")
            return
        }
        
        guard !passwordTextField.text!.isEmpty else {
            print("empty password")
            return
        }
        
        var request = URLRequest(url: URL(string: "https://gd.proxied.io/auth/login")!)
        request.httpMethod = "POST"
        
        let dict: [String: String] = [
            "username": usernameTextField.text!,
            "password": passwordTextField.text!
        ]

        request.httpBody = try! JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return
            }

            let authReponse = try! JSONDecoder().decode(LoginResponse.self, from: data!)

            AuthManager.shared.user = authReponse.user
            AuthManager.shared.token = authReponse.auth.token

            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showDomainSearch", sender: self)
            }
        }

        task.resume()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}


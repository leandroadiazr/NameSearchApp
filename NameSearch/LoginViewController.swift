import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    @IBAction func loginButtonTapped(_ sender: UIButton) {
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

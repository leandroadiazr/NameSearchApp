import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let userManager = UserManager.shared
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard !usernameTextField.text!.isEmpty else {
            print("empty user name")
            return
        }
        
        guard !passwordTextField.text!.isEmpty else {
            print("empty password")
            return
        }
        
        guard let username = usernameTextField.text,
              let password = usernameTextField.text else {
            return
        }
        
        var request = URLRequest(url: URL(string: "https://gd.proxied.io/auth/login")!)
        request.httpMethod = "POST"
        
        let user: [String: String] = [
            "username": username,
            "password": password
        ]
        
                authenticateUser(user: user)
        
//        request.httpBody = try! JSONSerialization.data(withJSONObject: user, options: .fragmentsAllowed)
//        
//        let session = URLSession(configuration: .default)
//        let task = session.dataTask(with: request) { (data, response, error) in
//            guard error == nil else {
//                return
//            }
//            
//            let authReponse = try! JSONDecoder().decode(LoginResponse.self, from: data!)
//            
//            
//            AuthManager.shared.user = authReponse.user
//            AuthManager.shared.token = authReponse.auth.token
//            
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "showDomainSearch", sender: self)
//            }
//        }
//        
//        task.resume()
    }
    
    private func authenticateUser(user: [String: String]) {
        
        userManager.authUser(user: user) { [weak self] response  in
            guard let self = self else { return }
            
            switch response  {
            case .success(let authResponse):
                AuthManager.shared.user = authResponse?.user
                AuthManager.shared.token = authResponse?.auth.token
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showDomainSearch", sender: self)
                }
                
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.rawValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

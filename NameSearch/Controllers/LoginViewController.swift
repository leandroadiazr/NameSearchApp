import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let authUserNetworkManager      = AuthNetworkManager.shared
    var auth                        : Auth?
    var loginResponse               : LoginResponse?
    
    override func viewDidLoad() {
        setupUI()
    }
    
    private func setupUI() {
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard !usernameTextField.text!.isEmpty else {
            showCustomAlert(title: CustomMessages.emptyTitle, message: CustomMessages.emptyUser, actionTitle: CustomMessages.ok)
            return
        }
        
        guard !passwordTextField.text!.isEmpty else {
            showCustomAlert(title: CustomMessages.emptyTitle, message: CustomMessages.emptyPass, actionTitle: CustomMessages.ok)
            return
        }
        
        guard let username = usernameTextField.text,
              let password = usernameTextField.text else {
                  return
              }
        
        let user: [String: String] = [
            "username": username,
            "password": password
        ]
        
        authenticateUser(user: user, urlString: StaticUrls.userUrl)
    }
    
    private func authenticateUser(user: [String: String], urlString: String) {
        showCustomLoadingView()
        authUserNetworkManager.authProcess(with: user, withUrl: urlString, for: LoginResponse.self) { [weak self] response in
            guard let self = self else { return }
            
            switch response  {
            case .success(let authResponse):
                guard let authResponse = authResponse else { return }
                self.auth?.user = authResponse.user
                self.auth?.token = authResponse.auth.token
                self.authUserNetworkManager.userProfile = authResponse.auth
                self.dismissLoadingView()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showDomainSearch", sender: self)
                }
                
            case .failure(let error):
                let alert = UIAlertController(title: CustomMessages.error, message: error.rawValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: CustomMessages.ok, style: .default, handler: nil))
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

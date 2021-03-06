import UIKit




class CartViewController: UIViewController {
    
    
    @IBOutlet var payButton     : UIButton!
    @IBOutlet var tableView     : UITableView!
    
    let paymentNetworkManager   = PaymentsNetworkManager.shared
    var paymentsManager         : PaymentMethod?
    var authManager             = AuthNetworkManager.shared
    var domains: [Domain] = []
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        if paymentsManager == nil {
            self.performSegue(withIdentifier: "showPaymentMethods", sender: self)
        } else {
            performPayment(with: StaticUrls.paymentProcessUrl)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        updatePayButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "CartItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CartItemCell")
    }
    
    func updatePayButton() {
        if paymentsManager == nil {
            payButton.setTitle("Select a Payment Method", for: .normal)
        } else {
            var totalPayment = 0.00
            
            domains.forEach {
                let priceDouble     = Double($0.price.replacingOccurrences(of: "$", with: ""))!
                totalPayment        += priceDouble
            }
            
            let currencyFormatter           = NumberFormatter()
            currencyFormatter.numberStyle   = .currency
            
            payButton.setTitle("Pay \(currencyFormatter.string(from: NSNumber(value: totalPayment))!) Now", for: .normal)
        }
    }
    
    func performPayment(with urlString: String) {
        payButton.isEnabled = false
        guard let authToken = authManager.userProfile?.token, let paymentToken = paymentsManager?.token else { return }
        let _: [String: String] = [
            "auth": authToken,
            "token": paymentToken
        ]
        showCustomLoadingView()
        paymentNetworkManager.retreivePayments(with: StaticUrls.paymentMethodUrl, for: PaymentMethod.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.showCustomAlert(title: CustomMessages.done, message: CustomMessages.purchased, actionTitle: CustomMessages.ok)
                }
                self.dismissLoadingView()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showCustomAlert(title: CustomMessages.oops, message: error.rawValue, actionTitle: CustomMessages.ok)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PaymentMethodsViewController
        vc.delegate = self
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return domains.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemTableViewCell
        cell.delegate = self
        cell.nameLabel.text = domains[indexPath.row].name
        cell.priceLabel.text = domains[indexPath.row].price
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            domains.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            updatePayButton()
        }
    }
}

extension CartViewController: CartItemTableViewCellDelegate {
    
    func didRemoveFromCart() {
        self.tableView.setEditing(true, animated: true)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        updatePayButton()
    }
}

extension CartViewController: PaymentMethodsViewControllerDelegate {
    func didSelectPaymentMethod(method: PaymentMethod) {
        self.paymentsManager = method
        updatePayButton()
    }
}

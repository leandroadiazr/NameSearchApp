import UIKit




class CartViewController: UIViewController {

    
    @IBOutlet var payButton     : UIButton!
    @IBOutlet var tableView     : UITableView!
    let paymentUrlString        = "https://gd.proxied.io/payments/process"
    let paymentNetworkManager   = AuthNetworkManager.shared
    let paymentsManager         = PaymentsManager.shared
    let authManager             = AuthManager.shared
    var domains: [Domain] = []
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        if paymentsManager.selectedPaymentMethod == nil {
            self.performSegue(withIdentifier: "showPaymentMethods", sender: self)
        } else {
            performPayment(with: paymentUrlString)
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
        if paymentsManager.selectedPaymentMethod == nil {
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

    //MARK:-Net Call
    func performPayment(with urlString: String) {
        payButton.isEnabled = false

        let paymentMethod: [String: String] = [
            "auth": AuthManager.shared.token!,
            "token": paymentsManager.selectedPaymentMethod!.token
        ]
        paymentNetworkManager.authProcess(with: paymentMethod, withUrl: urlString, for: PaymentsManager.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.showCustomAlert(title: "All done!", message: "Your purchase is complete!", actionTitle: "Ok")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                self.showCustomAlert(title: "Oops!", message: error.rawValue, actionTitle: "Ok")
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PaymentMethodsViewController
        vc.delegate = self
    }
}

extension CartViewController: UITableViewDataSource {
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
}

extension CartViewController: CartItemTableViewCellDelegate {
    func didRemoveFromCart() {
        updatePayButton()
        tableView.reloadData()
    }
}

extension CartViewController: PaymentMethodsViewControllerDelegate {
    func didSelectPaymentMethod() {
        updatePayButton()
    }
}

import UIKit

class CartViewController: UIViewController {

    @IBOutlet var payButton: UIButton!
    @IBOutlet var tableView: UITableView!

    @IBAction func payButtonTapped(_ sender: UIButton) {
        if PaymentsManager.shared.selectedPaymentMethod == nil {
            self.performSegue(withIdentifier: "showPaymentMethods", sender: self)
        } else {
            performPayment()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CartItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CartItemCell")
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

    func updatePayButton() {
        if PaymentsManager.shared.selectedPaymentMethod == nil {
            payButton.setTitle("Select a Payment Method", for: .normal)
        } else {
            var totalPayment = 0.00

            ShoppingCart.shared.domains.forEach {
                let priceDouble = Double($0.price.replacingOccurrences(of: "$", with: ""))!
                totalPayment += priceDouble
            }

            let currencyFormatter = NumberFormatter()
            currencyFormatter.numberStyle = .currency

            payButton.setTitle("Pay \(currencyFormatter.string(from: NSNumber(value: totalPayment))!) Now", for: .normal)
        }
    }

    func performPayment() {
        payButton.isEnabled = false

        let dict: [String: String] = [
            "auth": AuthManager.shared.token!,
            "token": PaymentsManager.shared.selectedPaymentMethod!.token
        ]

        var request = URLRequest(url: URL(string: "https://gd.proxied.io/payments/process")!)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: dict, options: .fragmentsAllowed)

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let controller = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: .alert)

                let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
                    self.payButton.isEnabled = true
                }

                controller.addAction(action)

                DispatchQueue.main.async {
                    self.present(controller, animated: true)
                }
            } else {
                let controller = UIAlertController(title: "All done!", message: "Your purchase is complete!", preferredStyle: .alert)

                let action = UIAlertAction(title: "Ok", style: .default) { _ in }

                controller.addAction(action)

                DispatchQueue.main.async {
                    self.present(controller, animated: true)
                }
            }

        }
        task.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PaymentMethodsViewController
        vc.delegate = self
    }
}

extension CartViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingCart.shared.domains.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemTableViewCell

        cell.delegate = self

        cell.nameLabel.text = ShoppingCart.shared.domains[indexPath.row].name
        cell.priceLabel.text = ShoppingCart.shared.domains[indexPath.row].price

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

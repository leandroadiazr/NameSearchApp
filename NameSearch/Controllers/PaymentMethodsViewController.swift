import UIKit

protocol PaymentMethodsViewControllerDelegate {
    func didSelectPaymentMethod(method: PaymentMethod)
}

class PaymentMethodsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var delegate: PaymentMethodsViewControllerDelegate?
    let paymentNetworkManager   = PaymentsNetworkManager.shared
//    let paymentManager          = PaymentsManager.shared
    var selectedPayment         : PaymentMethod?
    var paymentMethods: [PaymentMethod] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        choosePaymentType(with: StaticUrls.paymentMethodUrl)
    }
    
    private func choosePaymentType(with urlString: String) {
        paymentNetworkManager.retreivePayments(with: urlString, for: PaymentMethod.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let payment):
                guard let availablePayments = payment else { return }
                self.paymentMethods.append(contentsOf: availablePayments)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showCustomAlert(title: CustomMessages.paymentError, message: error.rawValue, actionTitle: CustomMessages.ok)
                }
            }
        }
    }
}

extension PaymentMethodsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let method = paymentMethods[indexPath.row]
        
        cell.textLabel!.text = method.name
        
        if let lastFour = method.lastFour {
            cell.detailTextLabel!.text = "Ending in \(lastFour)"
        } else {
            cell.detailTextLabel!.text = method.displayFormattedEmail!
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let method = paymentMethods[indexPath.row]
//        paymentManager.selectedPaymentMethod = method
        selectedPayment = method
        dismiss(animated: true) {
            self.delegate?.didSelectPaymentMethod(method: self.selectedPayment!)
        }
    }
}

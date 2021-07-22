
import UIKit

class DomainSearchViewController: UIViewController {
    
    @IBOutlet var searchTermsTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cartButton: UIButton!
    
    let networkManager = NetworkManager.shared
    var shoppingCart: [Domain] = []

    var isSearchEntered: Bool { return !searchTermsTextField.text!.isEmpty }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard isSearchEntered else {
            showCustomAlert(title: CustomMessages.emptyTitle, message: CustomMessages.checkInput, actionTitle: CustomMessages.ok)
            return
        }
        if let searchTerms = searchTermsTextField.text {
            searchTermsTextField.resignFirstResponder()
            loadData(with: searchTerms)
        }
    }
    
    @IBAction func cartButtonTapped(_ sender: UIButton) {}

    var data: [Domain] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCartButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func loadData(with searchTerms: String) {
        let dispatchGroup = DispatchGroup()
        
        //MARK:- EXACT RESULTS
        dispatchGroup.enter()
        networkManager.getDomains(for: searchTerms, withUrl: StaticUrls.exactURL, for: DomainSearchExactMatchResponse.self) { [weak self] exactResults in
            guard let self = self else {return}
            switch exactResults {
            case .success(let exactMatchResponse):
                guard let exactDomainPriceInfo = exactMatchResponse?.products.first(where: { $0.productId == exactMatchResponse?.domain.productId })?.priceInfo else { return }
                guard let domain = exactMatchResponse?.domain else { return }
                
                let result = Domain(name: domain.fqdn, price: exactDomainPriceInfo.currentPriceDisplay, productId: domain.productId)
                self.data.append(result)
            case .failure(let error):
                self.showCustomAlert(title: CustomMessages.error, message: error.rawValue, actionTitle: CustomMessages.ok)
            
                break
            }
            dispatchGroup.leave()
        }
        
        //MARK:- SUGESTIONS
        dispatchGroup.enter()
        networkManager.getDomains(for: searchTerms, withUrl: StaticUrls.sugestedURL, for: DomainSearchRecommendedResponse.self) { [weak self] recomendedResults in
            guard let self = self else {return}
            switch recomendedResults {
            case .success(let recomended):
                guard let recomendedPriceInfo = recomended?.products.first(where: { $0.productId == recomended?.domains.first?.productId })?.priceInfo else { return }
                guard let recomendedDomains = recomended?.domains else { return }
                
                for domain in recomendedDomains {
                    let result = Domain(name: domain.fqdn, price: recomendedPriceInfo.currentPriceDisplay, productId: domain.productId)
                    self.data.append(result)
                }
            case .failure(let error):
                self.showCustomAlert(title: CustomMessages.error, message: error.rawValue, actionTitle: CustomMessages.ok)
                break
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureCartButton() {
        cartButton.isEnabled = !shoppingCart.isEmpty
        cartButton.backgroundColor = cartButton.isEnabled ? .black : .lightGray
    }
}

extension DomainSearchViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let item = data[indexPath.row]
    
        cell.textLabel!.text = item.name
        cell.detailTextLabel!.text = item.price
        let selected = shoppingCart.contains(where: { $0.name == data[indexPath.row].name })
        DispatchQueue.main.async {
            cell.setSelected(selected, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let domain = data[indexPath.row]
        shoppingCart.append(domain)
        configureCartButton()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let domain = data[indexPath.row]
        shoppingCart = shoppingCart.filter { $0.name != domain.name }
        configureCartButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "CartButtonSegue" {
              let cartVC: CartViewController = segue.destination as! CartViewController
              cartVC.domains.append(contentsOf: shoppingCart)
          }
      }
}

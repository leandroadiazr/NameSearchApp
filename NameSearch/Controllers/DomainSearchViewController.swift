
import UIKit

class DomainSearchViewController: UIViewController {
    
    @IBOutlet var searchTermsTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cartButton: UIButton!
    let exactURL  = "https://gd.proxied.io/search/exact"
    let sugestedURL = "https://gd.proxied.io/search/spins"
    let networkManager = NetworkManager.shared
  
    var isSearchEntered: Bool { return !searchTermsTextField.text!.isEmpty }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard isSearchEntered else {
            showCustomAlert(title: "Empty Field", message: "Please check your input...", actionTitle: "Ok")
            return
        }
        if let searchTerms = searchTermsTextField.text {
            searchTermsTextField.resignFirstResponder()
            loadData(with: searchTerms)
        }
    }
    
    @IBAction func cartButtonTapped(_ sender: UIButton) {
        
    }

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
            networkManager.getDomains(for: searchTerms, withUrl: exactURL, for: DomainSearchExactMatchResponse.self) { [weak self] exactResults in
                guard let self = self else {return}
                switch exactResults {
                case .success(let exactMatchResponse):
                    guard let exactDomainPriceInfo = exactMatchResponse?.products.first(where: { $0.productId == exactMatchResponse?.domain.productId })?.priceInfo else { return }
                    guard let domain = exactMatchResponse?.domain else { return }
                    
                    let result = Domain(name: domain.fqdn, price: exactDomainPriceInfo.currentPriceDisplay, productId: domain.productId)
                    self.data.append(result)
                case .failure(let error):
                    self.showCustomAlert(title: "Error Occurred", message: error.rawValue, actionTitle: "Ok")
                    print(error.rawValue)
                    break
                }
                dispatchGroup.leave()
            }
            
            //MARK:- SUGESTIONS
            dispatchGroup.enter()
            networkManager.getDomains(for: searchTerms, withUrl: sugestedURL, for: DomainSearchRecommendedResponse.self) { [weak self] recomendedResults in
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
                    self.showCustomAlert(title: "Error Occurred", message: error.rawValue, actionTitle: "Ok")
                    break
                }
                dispatchGroup.leave()
            }
  
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
       
        
//
//        let session = URLSession(configuration: .default)
//
//        var urlComponents = URLComponents(string: "https://gd.proxied.io/search/exact")!
//        urlComponents.queryItems = [
//            URLQueryItem(name: "q", value: searchTerms)
//        ]
//
//        var request = URLRequest(url: urlComponents.url!)
//        request.httpMethod = "GET"
//
//        let task = session.dataTask(with: request) { (data, response, error) in
//            guard error == nil else { return }
//
//            if let data = data {
//                let exactMatchResponse = try! JSONDecoder().decode(DomainSearchExactMatchResponse.self, from: data)
//
//                var suggestionsComponents = URLComponents(string: "https://gd.proxied.io/search/spins")!
//                suggestionsComponents.queryItems = [
//                    URLQueryItem(name: "q", value: searchTerms)
//                ]
//
//                var suggestionsRequest = URLRequest(url: suggestionsComponents.url!)
//                suggestionsRequest.httpMethod = "GET"
//
//                let suggestionsTask = session.dataTask(with: suggestionsRequest) { (suggestionsData, suggestionsResponse, suggestionsError) in
//                    guard error == nil else { return }
//
//                    if let suggestionsData = suggestionsData {
//                        let suggestionsResponse = try! JSONDecoder().decode(DomainSearchRecommendedResponse.self, from: suggestionsData)
//
//                        let exactDomainPriceInfo = exactMatchResponse.products.first(where: { $0.productId == exactMatchResponse.domain.productId })!.priceInfo
//                        let exactDomain = Domain(name: exactMatchResponse.domain.fqdn,
//                                                 price: exactDomainPriceInfo.currentPriceDisplay,
//                                                 productId: exactMatchResponse.domain.productId)
//
//                        let suggestionDomains = suggestionsResponse.domains.map { domain -> Domain in
//                            let priceInfo = suggestionsResponse.products.first(where: { price in
//                                price.productId == domain.productId
//                            })!.priceInfo
//
//                            return Domain(name: domain.fqdn, price: priceInfo.currentPriceDisplay, productId: domain.productId)
//                        }
//
//                        self.data = [exactDomain] + suggestionDomains
//                        print(self.data)
//
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
                
//                suggestionsTask.resume()
//            }
//        }
//
//        task.resume()
    }
    
    private func configureCartButton() {
        cartButton.isEnabled = !ShoppingCart.shared.domains.isEmpty
        cartButton.backgroundColor = cartButton.isEnabled ? .black : .lightGray
    }
}

extension DomainSearchViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        let item = data[indexPath.row]
        
        cell.textLabel!.text = item.name
        cell.detailTextLabel!.text = item.price
        
        let selected = ShoppingCart.shared.domains.contains(where: { $0.name == data[indexPath.row].name })
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
        ShoppingCart.shared.domains.append(domain)
        configureCartButton()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let domain = data[indexPath.row]
        ShoppingCart.shared.domains = ShoppingCart.shared.domains.filter { $0.name != domain.name }
        configureCartButton()
    }
}

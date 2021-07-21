import Foundation
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
            let alert = UIAlertController(title: "Empty Field", message: "Please check your input..." , preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        searchTermsTextField.resignFirstResponder()
        loadData()
    }
    
    @IBAction func cartButtonTapped(_ sender: UIButton) {
        
    }
    
    
    var retreivedDomain: [Domain] = []
    var recomendedationDomain : [Domain] = []
    var data: [Domain]?
    
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
    
    func loadData() {
        guard let searchTerms = searchTermsTextField.text else {
            return
        }
        
        
        let urls = [exactURL, sugestedURL]
        
        for url in urls {
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            //MARK:- EXACT RESULTS
            networkManager.getDomains(for: searchTerms, withUrl: exactURL, for: DomainSearchExactMatchResponse.self) { exactResults in
                switch exactResults {
                case .success(let exactMatchResponse):
                    guard let exactDomainPriceInfo = exactMatchResponse?.products.first(where: { $0.productId == exactMatchResponse?.domain.productId })?.priceInfo else { return }
                    guard let domain = exactMatchResponse?.domain else {
                        return
                    }
                    
                    let result = Domain(name: domain.fqdn, price: exactDomainPriceInfo.currentPriceDisplay, productId: domain.productId)
                    self.retreivedDomain.append(result)
                    print("Resultssssss ",result)

//                    self.data?.append(result)
                case .failure(let error):
                    //manage error
                    print(error.rawValue)
                    break
                }
            }
            dispatchGroup.leave()
            
            //MARK:- SUGESTIONS
            dispatchGroup.enter()
            networkManager.getDomains(for: searchTerms, withUrl: sugestedURL, for: DomainSearchRecommendedResponse.self) { recomendedResults in
                switch recomendedResults {
                case .success(let recomended):
                    
                    guard let recomendedPriceInfo = recomended?.products.first(where: { $0.productId == recomended?.domains.first?.productId })?.priceInfo else { return }
                    
                    guard let recomendedDomains = recomended?.domains else { return }
                    
                    for domain in recomendedDomains {
                        let result = Domain(name: domain.fqdn, price: recomendedPriceInfo.currentPriceDisplay, productId: domain.productId)
                        self.recomendedationDomain.append(result)
                        self.data?.append(result)
                        print("Resultssssss@@@@ ",result)
                    }
                    
                case .failure(let error):
                    print(error.rawValue)
                    break
                    
                }
            }
            dispatchGroup.leave()
            
            dispatchGroup.notify(queue: .main) {
                                
                self.data?.append(contentsOf: self.retreivedDomain)
                self.data?.append(contentsOf: self.recomendedationDomain)
                print("Printing from the .notify method: ", self.data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

                
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

extension DomainSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        cell.textLabel!.text = data![indexPath.row].name
        cell.detailTextLabel!.text = data![indexPath.row].price
        
        let selected = ShoppingCart.shared.domains.contains(where: { $0.name == data![indexPath.row].name })
        
        DispatchQueue.main.async {
            cell.setSelected(selected, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension DomainSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let domain = data![indexPath.row]
        ShoppingCart.shared.domains.append(domain)
        
        configureCartButton()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let domain = data![indexPath.row]
        ShoppingCart.shared.domains = ShoppingCart.shared.domains.filter { $0.name != domain.name }
        
        configureCartButton()
    }
}

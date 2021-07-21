//
//  _DomainSearchViewController.swift
//  NameSearch
//
//  Created by Leandro Diaz on 7/20/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import UIKit
/*
struct Domain {
    let name: String
    let price: String
    let productId: Int
}

class DomainSearchViewController: UIViewController {

    @IBOutlet var searchTermsTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cartButton: UIButton!

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchTermsTextField.resignFirstResponder()
        loadData()
    }

    @IBAction func cartButtonTapped(_ sender: UIButton) {

    }

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
        let searchTerms = searchTermsTextField.text!
        let session = URLSession(configuration: .default)

        var urlComponents = URLComponents(string: "https://gd.proxied.io/search/exact")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: searchTerms)
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }

            if let data = data {
                let exactMatchResponse = try! JSONDecoder().decode(DomainSearchExactMatchResponse.self, from: data)

                var suggestionsComponents = URLComponents(string: "https://gd.proxied.io/search/spins")!
                suggestionsComponents.queryItems = [
                    URLQueryItem(name: "q", value: searchTerms)
                ]

                var suggestionsRequest = URLRequest(url: suggestionsComponents.url!)
                suggestionsRequest.httpMethod = "GET"

                let suggestionsTask = session.dataTask(with: suggestionsRequest) { (suggestionsData, suggestionsResponse, suggestionsError) in
                    guard error == nil else { return }

                    if let suggestionsData = suggestionsData {
                        let suggestionsResponse = try! JSONDecoder().decode(DomainSearchRecommendedResponse.self, from: suggestionsData)

                        let exactDomainPriceInfo = exactMatchResponse.products.first(where: { $0.productId == exactMatchResponse.domain.productId })!.priceInfo
                        let exactDomain = Domain(name: exactMatchResponse.domain.fqdn,
                                                 price: exactDomainPriceInfo.currentPriceDisplay,
                                                 productId: exactMatchResponse.domain.productId)

                        let suggestionDomains = suggestionsResponse.domains.map { domain -> Domain in
                            let priceInfo = suggestionsResponse.products.first(where: { price in
                                price.productId == domain.productId
                            })!.priceInfo

                            return Domain(name: domain.fqdn, price: priceInfo.currentPriceDisplay, productId: domain.productId)
                        }

                        self.data = [exactDomain] + suggestionDomains

                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }

                suggestionsTask.resume()
            }
        }

        task.resume()
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
*/

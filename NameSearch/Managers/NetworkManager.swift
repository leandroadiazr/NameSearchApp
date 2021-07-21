//
//  NetworkManager.swift
//  NameSearch
//
//  Created by Leandro Diaz on 7/20/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

class NetworkManager{
    static let shared = NetworkManager()
    
    func getDomains<T: Codable>(for searchTerms: String, withUrl urlString: String, for type: T.Type, completion: @escaping (Result<T?, CustomError>)  -> Void) {
        
        guard var urlComponent = URLComponents(string: urlString) else {
            completion(.failure(.invalid))
            return
        }
        urlComponent.queryItems = [
            URLQueryItem(name: "q", value: searchTerms)
        ]
        
        var request = URLRequest(url: urlComponent.url!)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalid))
                return
            }
            
            guard let result = response as? HTTPURLResponse, result.statusCode == 200 else {
                completion(.failure(.invalid))
                return }
            
            guard let data = data else {
                completion(.failure(.invalid))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let dataReceived = try decoder.decode(T.self, from: data)
                completion(.success(dataReceived))
            } catch {
                completion(.failure(.invalid))
            }
        }
        dataTask.resume()
    }
}

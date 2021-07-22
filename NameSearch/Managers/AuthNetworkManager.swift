//
//  AuthNetworkManager.swift
//  NameSearch
//
//  Created by Leandro Diaz on 7/20/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

class AuthNetworkManager {
    
    static let shared = AuthNetworkManager()

    func authProcess<T: Codable>(with requestData: [String : String], withUrl urlString: String, for type: T.Type, completion: @escaping (Result<T?, CustomError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalid))
            return
        }
        print(url)
        var request = URLRequest(url: url)
        guard let encoding = try? JSONSerialization.data(withJSONObject: requestData, options: .fragmentsAllowed) else {
            completion(.failure(.invalid))
            return
        }
        request.httpBody = encoding
        request.httpMethod = "POST"

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

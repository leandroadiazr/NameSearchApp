//
//  UserManager.swift
//  NameSearch
//
//  Created by Leandro Diaz on 7/20/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

class UserManager {
    
    static let shared = UserManager()
    let urlString = "https://gd.proxied.io/auth/login"
    
    func authUser(user: [String : String], completion: @escaping (Result<LoginResponse?, CustomError>) -> Void) {
        let endPoint = urlString
        
        guard let url = URL(string: endPoint) else {
            completion(.failure(.invalid))
            return
        }
        var request = URLRequest(url: url)
        guard let encoding = try? JSONSerialization.data(withJSONObject: user, options: .fragmentsAllowed) else {
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
                let dataReceived = try decoder.decode(LoginResponse.self, from: data)
                completion(.success(dataReceived))
            } catch {
                completion(.failure(.invalid))
            }
            
        }
        dataTask.resume()
    }
    
}

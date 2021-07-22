//
//  NameSearchTests.swift
//  NameSearchTests
//
//  Created by Mat Cartmill on 9/4/20.
//  Copyright © 2020 GoDaddy Inc. All rights reserved.
//

import XCTest
@testable import NameSearch

class NameSearchTests: XCTestCase {
    
    var loginVC = LoginViewController()
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        loginVC.loadViewIfNeeded()
    }
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func test_username_passwordfields_placeholder_is_correct() {
        let _ = loginVC.view
        XCTAssertEqual("Username", loginVC.usernameTextField!.placeholder)
        XCTAssertEqual("Password", loginVC.passwordTextField!.placeholder)
    }
    
    func testIfLoginButtonHasActionAssigned() {
        //Check if Controller has UIButton property
        let loginButton: UIButton = loginVC.loginButton
        XCTAssertNotNil(loginButton, "View Controller does not have UIButton property")
        
        // Attempt Access UIButton Actions
        guard let loginButtonActions = loginButton.actions(forTarget: loginVC, forControlEvent: .touchUpInside) else {
            XCTFail("UIButton does not have actions assigned for Control Event .touchUpInside")
            return
        }
        
        // Assert UIButton has action with a method name
        XCTAssertTrue(loginButtonActions.contains("loginButtonTapped:"))
    }
    
    func test_Generic_Network_Request() throws {
        let netCall = NetCallLoader.shared
        
        let dictionary : [String: Any] = [ "name": "GoDaddy.com" ]
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        guard let url = URL(string: "https://gd.proxied.io/auth/login") else {
            return
        }
        
        netCall.testTheCall(forUrl: url, model: jsonString, completion: { response in
            XCTAssert(response != nil)
        })
        
    }
}


class NetCallLoader {
    static let shared = NetCallLoader()
    
    func testTheCall<T: Codable>(forUrl: URL, model: T?, completion: @escaping (T?) -> Void) {
        URLSession.shared.dataTask(with: forUrl) { data, response, error in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                let received = try decoder.decode(T.self, from: data)
                completion(received)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

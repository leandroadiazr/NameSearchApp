//
//  Constants.swift
//  NameSearch
//
//  Created by Leandro Diaz on 7/22/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

enum StaticUrls {
    static let userUrl                      = "https://gd.proxied.io/auth/login"
    static let exactURL                     = "https://gd.proxied.io/search/exact"
    static let sugestedURL                  = "https://gd.proxied.io/search/spins"
    static let paymentProcessUrl            = "https://gd.proxied.io/payments/process"
    static let paymentMethodUrl             = "https://gd.proxied.io/user/payment-methods"
}

enum CustomMessages {
    static let emptyTitle                   = "Empty"
    static let emptyUser                    = "Username cant' be empty"
    static let emptyPass                    = "Password cant' be empty"
    static let ok                           = "Ok"
    
    static let error                        = "Error Occurred"
    static let checkInput                   = "Please check your input..."
    static let oops                         = "Oops!"
    static let paymentError                 = "Payment Error"
    
    static let done                         = "All Done!"
    static let purchased                    = "Your purchase is complete!"
    
}

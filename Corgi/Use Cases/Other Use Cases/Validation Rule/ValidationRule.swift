//
//  URLValidationRule.swift
//  Corgi
//
//  Created by 서상의 on 2021/10/30.
//

import Foundation

enum Validation {
    case success(url: URL)
    case failure
}

struct ValidationRule {
    func validate(url: String) -> Validation {
        guard let percentEncoded = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let unwrappedURL = URL(string: percentEncoded) else { return .failure }
        
        return .success(url: unwrappedURL)
    }
}

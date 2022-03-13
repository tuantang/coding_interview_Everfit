//
//  CTAccessTokenAdapter.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//

import Alamofire

class CTAccessTokenAdapter: RequestInterceptor {
 
    var accessToken: String?
    
    init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
         
        var adapterRequest = urlRequest
        adapterRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        if let accessToken = self.accessToken {
            adapterRequest.headers.add(.authorization(bearerToken: accessToken))
        }
        completion(.success(adapterRequest))
     }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetry)
    }

}

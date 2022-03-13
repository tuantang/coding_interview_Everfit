//
//  CTAPI.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class CTAPI: NSObject {
    
    static let shared: CTAPI = CTAPI()
    private let manager: Session
    private let accessTokenAdapter: CTAccessTokenAdapter = CTAccessTokenAdapter()
    
    override init() {
        self.manager = Session(interceptor: self.accessTokenAdapter)
    }
    
    public func url(_ path: String) -> String {
        if path.contains("http")  {
            return path.replacingOccurrences(of: "http://", with: "https://")
        }
        return CTConstants.baseURL + path
    }
    
    func createRequest(_ path: String,
                       method: HTTPMethod = .get,
                       parameters: Parameters? = nil,
                       encoding: ParameterEncoding = URLEncoding.default) -> DataRequest {

        let request = self.manager.request(self.url(path), method: method, parameters: parameters, encoding: encoding, headers: nil)
            .validate(statusCode: 200..<300).responseData { response in
                if CTConstants.AppEnvironment == .Dev {
                    debugPrint("++++++++++++++++++++++++++++++")
                    debugPrint(response.request?.headers as Any)
                    debugPrint("")
                    debugPrint("All Response Info: \(response)")

                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                    }
                    debugPrint("++++++++++++++++++++++++++++++")
                }
        }

        return request
    }
}

extension DataRequest {
    @discardableResult
    public func responseObject<T: BaseMappable>(queue: DispatchQueue = .main, keyPath: String? = nil, mapToObject object: T? = nil, context: MapContext? = nil, completionHandler: @escaping (AFDataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.ObjectMapperSerializer(keyPath ?? "data", mapToObject: object, context: context), completionHandler: completionHandler)
    }

    @discardableResult
    public func responseArray<T: BaseMappable>(queue: DispatchQueue = .main, keyPath: String? = nil, context: MapContext? = nil, completionHandler: @escaping (AFDataResponse<[T]>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.ObjectMapperArraySerializer(keyPath ?? "data", context: context), completionHandler: completionHandler)
    }
}


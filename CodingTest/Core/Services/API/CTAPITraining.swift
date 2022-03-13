//
//  CTAPITraining.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import RxSwift

extension CTAPI {
        
    func fetchWorkouts() -> Observable<[CTWorkout]> {
        let url = CTConstants.baseURL + "/workouts"
        
        return Observable.create { observable -> Disposable in
            let request = self.createRequest(url, method: .get, parameters: nil).responseArray(completionHandler: { (response: AFDataResponse<[CTWorkout]>) in
                switch response.result {
                case .success(let results):
                    observable.onNext(results)
                    observable.onCompleted()
                case .failure(let rawError):
                    observable.onError(rawError)
                }
            })
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}

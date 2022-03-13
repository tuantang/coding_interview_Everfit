//
//  Constants.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//

import Foundation
import UIKit

let completeColor = UIColor(red: 116/255, green: 112/255, blue: 239/255, alpha: 1)
let unCompleteColor = UIColor(red: 247/255, green: 248/255, blue: 252/255, alpha: 1)
let titleColor = UIColor(red: 30/255, green: 10/255, blue: 60/255, alpha: 1)
let titleFutureColor = UIColor(red: 123/255, green: 126/255, blue: 145/255, alpha: 1)
let titleMissedColor = UIColor(red: 255/255, green: 94/255, blue: 94/255, alpha: 1)

struct CTConstants {
    
    enum Environment: String {
        case Dev
        case Staging
        case Production
    }
    
    static let AppEnvironment = Environment.Dev
    
    static var baseURL: String {
        switch AppEnvironment {
            case .Dev: return "https://demo2187508.mockable.io"
            case .Staging: return "https://demo2187508.mockable.io"
            case .Production: return "https://demo2187508.mockable.io"
        }
    }
}

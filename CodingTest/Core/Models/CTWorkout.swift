//
//  CTWorkout.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//

import ObjectMapper

class CTWorkout: NSObject, Mappable {
    
    var id: String?
    var assignments: [CTAssignment]?
    var day: Int?
    var date: Date?
    
    convenience init(date: Date) {
        self.init()
        self.date = date
    }
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        id <- map["_id"]
        assignments <- map["assignments"]
        day <- map["day"]
    }
    
}

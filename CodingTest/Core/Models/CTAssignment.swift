//
//  CTAssignment.swift
//  CodingTest
//
//  Created by Tang Tuan on 8/7/20.
//  Copyright © 2020 Tang Tuan. All rights reserved.
//

import ObjectMapper

enum CTWorkoutInfoState: Int {
    case assigned = 0
    case in_progress = 1
    case complete = 2
}

class CTAssignment: NSObject, Mappable {
    
    var id: String?
    var title: String?
    var status: CTWorkoutInfoState?
    var totalExercise: Int?
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        id <- map["_id"]
        title <- map["title"]
        status <- (map["status"], EnumTransform<CTWorkoutInfoState>())
        totalExercise <- map["total_exercise"]
    }
    
}

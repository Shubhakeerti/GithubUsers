//
//  UtilityClass.swift
//  GitHubUsers
//
//  Created by Shubhakeerti on 17/04/18.
//  Copyright © 2018 Shubhakeerti. All rights reserved.
//

import UIKit
import SwiftyJSON


struct UserStruct: Hashable {
    var name: String?
    var userId: String?
    var score: String?
    var type: String?
    var avatar: String?
    init(json: JSON) {
        name = json["login"].string
        userId = json["id"].number?.stringValue
        score = json["score"].string
        type = json["type"].string
        avatar = json["avatar_url"].string
    }
    
    init(name: String? = nil, userId: String? = nil, score: String? = nil, type: String? = nil, avatar: String? = nil) {
        self.name = name
        self.userId = userId
        self.score = score
        self.type = type
        self.avatar = avatar
    }
    
    var hashValue: Int {
        return (userId?.hashValue)!
    }
    
    static func == (lhs: UserStruct, rhs: UserStruct) -> Bool {
        return (lhs.name == rhs.name
            && lhs.userId == rhs.userId)
    }
}

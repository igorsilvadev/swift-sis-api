//
//  ImageObject.swift
//  
//
//  Created by Igor Samoel da Silva on 20/05/22.
//

import Foundation
import Vapor
//Custum key: https://www.swiftbysundell.com/articles/customizing-codable-types-in-swift/
struct ImageObject: Codable {
    var url: String
    var website: String
    var title: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case url = "murl"
        case website = "purl"
        case title = "t"
        case description = "desc"
    }
}

struct ImageObjectResponse: Codable, Content {
    var url: String
    var website: String
    var title: String
    var description: String
}

//
//  ReviewModel.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/4/21.
//

import Foundation

class ReviewModel: Codable {
    let user: Reviewer?
    let timeStamp: String?
    let rating: Decimal?
    let text: String?
    
    enum CodingKeys: String, CodingKey {
        case user
        case timeStamp = "time_created"
        case rating
        case text
    }
    
}

class Reviewer: Codable {
    let imageUrl: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageUrl = "image_url"
    }
}

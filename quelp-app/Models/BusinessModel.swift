//
//  BusinessModel.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/1/21.
//

import Foundation

class Business: Codable {
    let id: String
    let name: String
    let url: String
    let imageUrl: String
    let reviewCount: Int
    let alias: String
    let displayPhone: String
    let rating: Decimal
    let price: String
    let distance: Decimal
    let isClosed: Bool
    let phone: String
    let location: BusinessLocation
    let coordinates: LocationCoordinates
    let categories: [BusinessCategory]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case imageUrl = "image_url"
        case reviewCount = "review_count"
        case alias
        case displayPhone = "display_phone"
        case rating
        case price
        case distance
        case isClosed = "is_closed"
        case phone
        case location
        case coordinates
        case categories
    }
}

class LocationCoordinates: Codable {
    let latitude: Decimal
    let longitude: Decimal
}

class BusinessCategory: Codable {
    let title: String
    let alias: String
}

class BusinessLocation: Codable {
    let country: String
    let address1: String
    let zipCode: String
    let address2: String
    let displayAddress: [String]
    let state: String
    let city: String
    let address3: String
    
    enum CodingKeys: String, CodingKey {
        case country
        case address1
        case zipCode = "zip_code"
        case address2
        case displayAddress = "display_address"
        case state
        case city
        case address3
    }
}

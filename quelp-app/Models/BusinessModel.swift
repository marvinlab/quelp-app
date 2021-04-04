//
//  BusinessModel.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/1/21.
//

import Foundation

enum BusinessWeekDay: Int, Codable {
    case monday = 0
    case tuesday = 1
    case wednesday = 2
    case thursday = 3
    case friday = 4
    case saturday = 5
    case sunday = 6
}

class Business: Codable {
    let id: String?
    let name: String?
    let url: String?
    let imageUrl: String?
    let reviewCount: Int?
    let alias: String?
    let displayPhone: String?
    let rating: Decimal?
    let price: String?
    let distance: Decimal?
    let isClosed: Bool?
    let phone: String?
    let location: BusinessLocation?
    let coordinates: LocationCoordinates?
    let categories: [BusinessCategory]?
    let photoUrls: [String]?
    let businessHours: [BusinessHours]?
    
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
        case photoUrls = "photos"
        case businessHours = "hours"
    }
}

class LocationCoordinates: NSObject, Codable {
    var latitude: Double?
    var longitude: Double?
}

class BusinessCategory: Codable {
    let title: String?
    let alias: String?
}

class BusinessLocation: Codable {
    let country: String?
    let address1: String?
    let zipCode: String?
    let address2: String?
    let displayAddress: [String]?
    let state: String?
    let city: String?
    let address3: String?
    
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

class BusinessHours: Codable {
    let isOpenNow: Bool?
    let openHours: [OpenHour]?
    
    enum CodingKeys: String, CodingKey {
        case isOpenNow = "is_open_now"
        case openHours = "open"
    }
}

class OpenHour: Codable {
    let day: BusinessWeekDay?
    let start: String?
    let end: String?
}

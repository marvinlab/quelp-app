//
//  BusinessDetailViewModel.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/4/21.
//

import Foundation
import UIKit
import MapKit

class BusinessDetailViewModel {
    
    let businessImageUrl: String
    let businessName: String
    let ratingImage: UIImage
    let categoriesText: String
    let reviewsText: String
    let coordinates: LocationCoordinates
    let displayAdressText: String
    let openText: String
    let openHoursText: String
    
    init(business: Business) {
        businessImageUrl = business.imageUrl ?? ""
        businessName = business.name ?? ""
        ratingImage = #imageLiteral(resourceName: "small_\(business.rating ?? 0)")
        categoriesText = "categories" // to change
        reviewsText = "Based on \(business.reviewCount ?? 0)" // to change
        coordinates = business.coordinates!
        displayAdressText = business.location?.displayAddress?[0] ?? "" // to change
        openText = business.isClosed ?? false ? Constants.AppStrings.closed : Constants.AppStrings.open
        openHoursText = "open Hours Text" //to change
    }
}

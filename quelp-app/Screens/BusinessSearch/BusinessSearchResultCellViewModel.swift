//
//  BusinessSearchResultCellViewModel.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/2/21.
//

import Foundation
import UIKit


struct BusinessSearchResultCellViewModel {
    let businessImageUrl: String
    let name: String
    let ratingString: String
    let distance: String
    let isBusinessClosed: Bool
    let businessStatusString: String
    let categories: String
    let city: String
    
    init(business: Business) {
        self.businessImageUrl = business.imageUrl ?? ""
        self.name = business.name ?? ""
        self.ratingString = String(format: Constants.AppStrings.ratingString, "\(business.rating ?? 0)", "\(business.reviewCount ?? 0)")
        self.distance = String(format: Constants.AppStrings.distanceString, business.distance! as CVarArg)
        self.businessStatusString = business.isClosed ?? false ? Constants.AppStrings.closed : Constants.AppStrings.open
        self.isBusinessClosed = business.isClosed ?? false
        var categoryString = ""
        business.categories?.forEach { (category) in
            categoryString.append("\(category.title ?? ""),")
        }
        self.categories = categoryString
        self.city = business.location?.city ?? ""
    }
}

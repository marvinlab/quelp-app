//
//  BusinessSearchResultCellViewModel.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/2/21.
//

import Foundation
import UIKit


struct BusinessSearchResultCellViewModel {
    let businessId: String
    let businessImageUrl: String
    let name: String
    let ratingString: String
    let distance: String
    let isBusinessClosed: Bool
    let businessStatusString: String
    let categories: String
    let city: String
    let ratingStarImage: UIImage
    let ratingValue: Decimal
    let distanceValue: Decimal
    
    init(business: Business) {
        self.businessId = business.id ?? ""
        self.businessImageUrl = business.imageUrl ?? ""
        self.name = business.name ?? ""
        self.ratingString = String(format: Constants.AppStrings.ratingString, "\(business.reviewCount ?? 0)")
        
        let distanceDouble = Double(truncating: business.distance! as NSNumber)
        let distanceMeter = Measurement(value: distanceDouble, unit: UnitLength.meters)
        let distanceKm = distanceMeter.converted(to: UnitLength.kilometers)
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 2
        let kmString = formatter.string(from: distanceKm)
        self.distance = String(format: Constants.AppStrings.distanceString, kmString)
        self.businessStatusString = business.isClosed ?? false ? Constants.AppStrings.closed : Constants.AppStrings.open
        self.isBusinessClosed = business.isClosed ?? false
        var categoryString = ""
        let stringCategories: [String] = (business.categories ?? []).map({
            return $0.title ?? ""
        })
        categoryString = stringCategories.joined(separator: ", ")
        self.categories = categoryString
        self.city = business.location?.city ?? ""
        let starRatingFileName = "small_\(business.rating ?? 0)"
        self.ratingStarImage = #imageLiteral(resourceName: starRatingFileName)
        self.ratingValue = business.rating ?? 0.0
        self.distanceValue = business.distance ?? 0.0
    }
}

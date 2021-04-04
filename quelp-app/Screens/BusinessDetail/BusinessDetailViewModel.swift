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
        categoriesText = BusinessDetailViewModel.formatCategories(categories: business.categories ?? [])
        reviewsText = BusinessDetailViewModel.formatReviewsText(reviewCount: business.reviewCount ?? 0, rating: business.rating ?? 0.0)
        coordinates = business.coordinates!
        displayAdressText = BusinessDetailViewModel.formatDisplayAddress(displayAddressStrings: business.location?.displayAddress ?? [])
        openText = business.isClosed ?? false ? Constants.AppStrings.closed : Constants.AppStrings.open
        openHoursText = BusinessDetailViewModel.formatOpenHours(openHours: business.businessHours?.first?.openHours ?? [])
    }
    
    private class func formatCategories(categories: [BusinessCategory]) -> String {
        let stringCategories: [String] = categories.map({
            return $0.title ?? ""
        })
        return stringCategories.joined(separator: ", ")
    }
    
    private class func formatReviewsText(reviewCount: Int, rating: Decimal) -> String {
        return String(format: Constants.AppStrings.ratingReviewString, "\(rating)", "\(reviewCount)")
    }
    
    private class func formatDisplayAddress(displayAddressStrings: [String]) -> String {
        return displayAddressStrings.joined(separator: ", ")
    }
    
    private class func formatOpenHours(openHours: [OpenHour]) -> String {
        if openHours.count == 0 {
            return Constants.AppStrings.noAvailableHoursProvided
        }
        let stringHours: [String] = openHours.map({
            let startTime = dateTimeChangeFormat(str: $0.start ?? "", inDateFormat: "HHmm", outDateFormat: "h:mm a")
            let endTime = dateTimeChangeFormat(str: $0.end ?? "", inDateFormat: "HHmm", outDateFormat: "h:mm a")
            let openHoursFormat = "%@ :\t%@ to %@"
            let dayString = BusinessDetailViewModel.dayOfWeekDisplayString(weekDay: $0.day ?? .monday)
            return String(format: openHoursFormat, dayString, startTime, endTime)
        })
        return stringHours.joined(separator: "\n\n")
    }
    
    private class func dateTimeChangeFormat(str stringWithDate: String, inDateFormat: String, outDateFormat: String) -> String {
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = inDateFormat

        let outFormatter = DateFormatter()
        outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.dateFormat = outDateFormat

        let inStr = stringWithDate
        let date = inFormatter.date(from: inStr)!
        return outFormatter.string(from: date)
    }
    
    private class func dayOfWeekDisplayString(weekDay: BusinessWeekDay) -> String {
        switch weekDay {
        case .monday:
            return "Mon"
        case .tuesday:
            return "Tue"
        case .wednesday:
            return "Wed"
        case .thursday:
            return "Thu"
        case .friday:
            return "Fri"
        case .saturday:
            return "Sat"
        case .sunday:
            return "Sun"
        }
    }
    
}

//
//  ReviewCellModel.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/4/21.
//

import Foundation

class ReviewCellModel {
    let userImageUrl: String
    let userReviewText: String
    let reviewTimeStamp: String
    let rating: String
    
    init(review: ReviewModel) {
        userImageUrl = review.user?.imageUrl ?? ""
        userReviewText = review.text ?? ""
        reviewTimeStamp = ReviewCellModel.dateTimeChangeFormat(str: review.timeStamp ?? "", inDateFormat: "yyyy-MM-dd HH:mm:ss", outDateFormat: "MMM d, yyyy h:mm a")
        rating = "\(review.rating ?? 0)"
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
}

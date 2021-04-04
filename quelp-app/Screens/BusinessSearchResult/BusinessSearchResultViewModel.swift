//
//  BusinessSearchResultViewModel.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/2/21.
//

import Foundation
import UIKit


struct BusinessSearchResultViewModel {
    let resultsKeywordText: String
    let businesses: [Business]
    
    init(businesses: [Business], keyword: String, location: String) {
        self.businesses = businesses
        var keywordString = ""
        if keyword.trimmed != "" {
            keywordString.append("for \(keyword)")
        }
        
        if location.trimmed != "" {
            keywordString.append(" in \(location)")
        } else {
            keywordString.append(" in your location")
        }
        self.resultsKeywordText = String(format: Constants.AppStrings.weFoundString, "\(businesses.count)", keywordString)
    }
}

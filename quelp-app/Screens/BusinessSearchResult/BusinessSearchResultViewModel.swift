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
    
    init(businesses: [Business], keyword: String) {
        self.businesses = businesses
        self.resultsKeywordText = String(format: Constants.AppStrings.keywordResultString, "\(businesses.count)", keyword)
    }
}

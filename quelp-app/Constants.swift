//
//  Constants.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/1/21.
//

import Foundation
import UIKit


struct Constants {
    struct Api {
        static var baseURL = "https://api.yelp.com/v3/"
        static var getBusinesses = "businesses/search"
        static var getBusinessDetails = "businesses"
    }
    
    struct AppStrings {
        static let ratingString = "(%@ reviews)"
        static let open = "Open"
        static let closed = "Closed"
        static let distanceString = "%@ km away"
        static let keywordResultString = "We found %@ results for \"%@\""
        
        //Error
        static let emptySearchTextFieldError = "Please enter word to search."
        static let requestError = "An error occured with the request. Please try again."
    }
}

func showLoading() {
    DispatchQueue.main.async {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            hideLoading()
            let loadingView = QALoadingView.shared
            loadingView.showOverlay(view: topController.view)
        }
    }
}

func hideLoading() {
    QALoadingView.shared.hideOverlayView()
}



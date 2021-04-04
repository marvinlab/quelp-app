//
//  ReviewsViewModel.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/4/21.
//

import Foundation

class ReviewsViewModel {
    let reviews: [ReviewModel]
    
    init(reviewModels: [ReviewModel]) {
        reviews = reviewModels
    }
}

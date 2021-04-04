//
//  ReviewCell.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/4/21.
//

import UIKit
import IBAnimatable

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: AnimatableImageView!
    @IBOutlet weak var reviewTextLabel: AnimatableLabel!
    @IBOutlet weak var timeStampLabel: AnimatableLabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingLabel: AnimatableLabel!
    
    var reviewCellModel: ReviewCellModel! {
        didSet {
            userImageView.loadImageFromURL(reviewCellModel.userImageUrl, failOverImage: nil, showIndicator: false)
            reviewTextLabel.text = reviewCellModel.userReviewText
            timeStampLabel.text = reviewCellModel.reviewTimeStamp
            ratingLabel.text = reviewCellModel.rating
            ratingImageView.image = #imageLiteral(resourceName: "small_\(reviewCellModel.rating)")
        }
    }
    
}

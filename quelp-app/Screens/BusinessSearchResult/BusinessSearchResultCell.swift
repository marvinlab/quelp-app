//
//  BusinessSearchResultCell.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/2/21.
//

import UIKit
import IBAnimatable

class BusinessSearchResultCell: UITableViewCell {
    @IBOutlet weak var businessImageView: AnimatableImageView!
    @IBOutlet weak var businessNameLabel: AnimatableLabel!
    @IBOutlet weak var businessCategoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var businessStatusLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    
    var businessViewModel: BusinessSearchResultCellViewModel! {
        didSet {
            let failover = #imageLiteral(resourceName: "yelp_logo")
            businessImageView?.loadImageFromURL(businessViewModel.businessImageUrl, failOverImage: failover, showIndicator: false)
            businessNameLabel?.text = businessViewModel.name
            businessCategoryLabel?.text = businessViewModel.categories
            ratingLabel?.text = businessViewModel.ratingString
            cityLabel?.text = businessViewModel.city
            businessStatusLabel?.text = businessViewModel.businessStatusString
            businessStatusLabel?.textColor = businessViewModel.isBusinessClosed ? .red : .systemGreen
            distanceLabel?.text = businessViewModel.distance
            starImageView.image = businessViewModel.ratingStarImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

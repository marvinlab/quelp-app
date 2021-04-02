//
//  BusinessSearchResultCell.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/2/21.
//

import UIKit
import IBAnimatable

class BusinessSearchResultCell: UITableViewCell {
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: AnimatableLabel!
    @IBOutlet weak var businessCategoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var businessStatusLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var businessViewModel: BusinessSearchResultCellViewModel! {
        didSet {
            businessImageView.loadImageFromURL(businessViewModel.businessImageUrl, failOverImage: nil, showIndicator: true)
            businessNameLabel.text = businessViewModel.name
            businessCategoryLabel.text = businessViewModel.categories
            ratingLabel.text = businessViewModel.ratingString
            cityLabel.text = businessViewModel.city
            businessStatusLabel.text = businessViewModel.businessStatusString
            businessStatusLabel.textColor = businessViewModel.isBusinessClosed ? .red : .green
            distanceLabel.text = businessViewModel.distance
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

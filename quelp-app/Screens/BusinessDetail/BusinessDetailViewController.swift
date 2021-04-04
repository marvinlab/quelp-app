//
//  BusinessDetailViewController.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/3/21.
//

import UIKit
import IBAnimatable
import MapKit

class BusinessDetailViewController: UIViewController {
    
    @IBOutlet weak var businessImage: AnimatableImageView!
    @IBOutlet weak var businessNameLabel: AnimatableLabel!
    @IBOutlet weak var reviewsCountLabel: AnimatableLabel!
    @IBOutlet weak var categoriesLabel: AnimatableLabel!
    @IBOutlet weak var openLabel: AnimatableLabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: AnimatableLabel!
    @IBOutlet weak var openSchedLabel: AnimatableLabel!
    @IBOutlet weak var ratingImage: UIImageView!
    
    var businessDetailViewModel: BusinessDetailViewModel! {
        didSet {
            DispatchQueue.main.async {
                self.businessImage?.loadImageFromURL(self.businessDetailViewModel.businessImageUrl, failOverImage: nil, showIndicator: false)
                self.businessNameLabel?.text = self.businessDetailViewModel.businessName
                self.reviewsCountLabel?.text = self.businessDetailViewModel.reviewsText
                self.categoriesLabel?.text = self.businessDetailViewModel.categoriesText
                self.openLabel?.text = self.businessDetailViewModel.openText
                self.setMapViewFromCoordinates()
                self.addressLabel?.text = self.businessDetailViewModel.displayAdressText
                self.openSchedLabel?.text = self.businessDetailViewModel.openHoursText
                self.ratingImage?.image = self.businessDetailViewModel.ratingImage
            }
        }
    }
    
    init(withTitle title: String) {
        super.init(nibName: "BusinessDetailViewController", bundle: nil)
    }
    
    func setMapViewFromCoordinates() {
        let annotation = MKPointAnnotation()
        let businessLatitude = self.businessDetailViewModel.coordinates.latitude ?? 0.0
        let businessLongitude = self.businessDetailViewModel.coordinates.longitude ?? 0.0
        annotation.coordinate = CLLocationCoordinate2D(latitude: businessLatitude, longitude: businessLongitude)
        annotation.title = self.businessDetailViewModel.businessName
        self.mapView?.addAnnotation(annotation)
        let locationRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        self.mapView?.setRegion(locationRegion, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

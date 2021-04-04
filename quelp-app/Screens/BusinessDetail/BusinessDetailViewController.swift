//
//  BusinessDetailViewController.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/3/21.
//

import UIKit
import IBAnimatable
import MapKit
import Material
import SwiftyJSON

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
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var displayPhoneLabel: AnimatableLabel!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var galleryHeaderLabel: AnimatableLabel!
    @IBOutlet weak var checkReviewsButton: FlatButton!
    
    
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
                self.setPhoneNumber(number: self.businessDetailViewModel.displayPhoneNumber)
                self.setupGallery()
            }
        }
    }
    
    init(withTitle title: String) {
        super.init(nibName: "BusinessDetailViewController", bundle: nil)
    }
    
    func setPhoneNumber(number: String) {
        if number == "" {
            phoneIcon.isHidden = true
            displayPhoneLabel.isHidden = true
            return
        }
        self.displayPhoneLabel.text = number
        self.displayPhoneLabel.textColor = .systemPurple
        self.phoneIcon.image = #imageLiteral(resourceName: "phone_icon_material").withRenderingMode(.alwaysTemplate).withTintColor(.purple)
    }
    
    func setCheckReviewsBtn() {
        checkReviewsButton.isHidden = self.businessDetailViewModel.reviewCount == 0
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
    
    func setupGallery() {
        if self.businessDetailViewModel.galleryImageUrls.count == 0 {
            self.galleryHeaderLabel.isHidden = true
            self.galleryCollectionView.isHidden = true
            return
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.galleryCollectionView.collectionViewLayout = layout
        
        self.galleryCollectionView.delegate = self
        self.galleryCollectionView.dataSource = self
        self.galleryCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "galleryImageCell")
        self.galleryCollectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func displayFullSizeImageWithUrl(url: String) {
        let previewVC = UIViewController()
        let previewImageView = UIImageView()
        previewVC.view.backgroundColor = .black
        previewImageView.frame.size = UIScreen.main.bounds.size
        previewImageView.contentMode = .scaleAspectFit
        previewVC.view.addSubview(previewImageView)
        previewImageView.loadImageFromURL(url, failOverImage: nil, showIndicator: true)
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    
    @IBAction func checkReviewsButton(_ sender: Any) {
        businessRequestProvider.request(.getReviews(id: businessDetailViewModel.businessId)) { (result) in
            switch result {
            case .success(let response):
                self.showReviewsPage(response: JSON(response.data))
            case .failure:
                print("error")
            }
        }
    }
    
    func showReviewsPage(response: JSON) {
        let reviewsJSON = response["reviews"].arrayValue
        var reviews: [ReviewModel] = []
        reviewsJSON.forEach { (reviewData) in
            reviews.append(try! JSONDecoder().decode(ReviewModel.self, from: reviewData.rawData()))
        }
        let reviewsPageViewModel = ReviewsViewModel(reviewModels: reviews)
        let reviewsPage = ReviewsViewController(withTitle: "Reviews")
        reviewsPage.reviewsViewModel = reviewsPageViewModel
        self.navigationController?.pushViewController(reviewsPage, animated: true)
    }
    
}

extension BusinessDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businessDetailViewModel.galleryImageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryImageCell", for: indexPath)
        let galleryImageView = UIImageView()
        galleryImageView.contentMode = .scaleAspectFill
        galleryImageView.loadImageFromURL(businessDetailViewModel.galleryImageUrls[indexPath.row], failOverImage: nil, showIndicator: false)
        galleryImageView.frame.size = CGSize(width: 100, height: 100)
        galleryImageView.clipsToBounds = true
        cell.addSubview(galleryImageView)
        cell.contentView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageUrl = businessDetailViewModel.galleryImageUrls[indexPath.row]
        self.displayFullSizeImageWithUrl(url: imageUrl)
    }
}

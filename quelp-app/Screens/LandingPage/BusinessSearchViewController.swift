//
//  BusinessSearchViewController.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/2/21.
//

import UIKit
import Material
import SwiftyJSON
import CoreLocation

class BusinessSearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: TextField!
    let locationManager = CLLocationManager()
    var userCoordinates: LocationCoordinates?
    init(withTitle title: String) {
        super.init(nibName: "BusinessSearchViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func setupTextField() {
        searchTextField.delegate = self
        searchTextField.setDefaultTextField()
    }
    
    func checkUserLocation() {
        switch locationManager.authorizationStatus {
        case .restricted, .denied, .notDetermined:
            userCoordinates = LocationCoordinates()
            userCoordinates?.longitude = -73.561668
            userCoordinates?.latitude = 45.508888
        default:
            if locationManager.delegate == nil {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
            userCoordinates = LocationCoordinates()
            userCoordinates?.longitude = locationManager.location?.coordinate.longitude
            userCoordinates?.latitude = locationManager.location?.coordinate.latitude
        }
    }

    @IBAction func searchAction(_ sender: Any) {
        searchForResults()
    }
    
    func searchForResults() {
        checkUserLocation()
        self.view.endEditing(true)
        if searchTextField.text?.trimmed != "" {
            searchBusiness()
        } else {
            searchTextField.setErroneousTextField(withErrorDetail: Constants.AppStrings.emptySearchTextFieldError)
        }
    }
    
    func searchBusiness() {
        businessRequestProvider.request(.getBusinesses(coordinates: userCoordinates!, term: searchTextField.text ?? "")) { (result) in
            switch result {
            case .success(let result):
                let jsonResponse = JSON(result.data)
                self.handleSuccessfulBusinessSearch(response: jsonResponse)
            case .failure:
                self.handleError()
            }
        }
    }
    
    func handleSuccessfulBusinessSearch(response: JSON) {
        var businesses: [Business] = []
        if let businessesJSON = response["businesses"].array {
            businessesJSON.forEach { (business) in
               let businessModel = try? JSONDecoder().decode(Business.self, from: business.rawData())
                businesses.append(businessModel!)
            }
        }
        let searchResultViewModel = BusinessSearchResultViewModel(businesses: businesses, keyword: searchTextField.text ?? "")
        let resultsPage = BusinessSearchResultViewController(withTitle: "Results")
        resultsPage.businessResultsViewModel = searchResultViewModel
        self.navigationController?.pushViewController(resultsPage, animated: true
        )
    }
    
    func handleError() {
        searchTextField.setErroneousTextField(withErrorDetail: Constants.AppStrings.requestError)
    }
    
    
}

extension BusinessSearchViewController: TextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchForResults()
        return true
    }
    
    func textField(textField: TextField, didChange text: String?) {
        searchTextField.setDefaultTextField()
    }
}

extension BusinessSearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let actualCoordinates = LocationCoordinates()
        actualCoordinates.longitude = locValue.longitude
        actualCoordinates.latitude = locValue.latitude
        self.userCoordinates = actualCoordinates
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        userCoordinates = LocationCoordinates()
        userCoordinates?.longitude = -73.561668
        userCoordinates?.latitude = 45.508888
    }
}

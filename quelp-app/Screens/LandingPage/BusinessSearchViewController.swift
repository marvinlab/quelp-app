//
//  BusinessSearchViewController.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/2/21.
//

import UIKit
import Material
import SwiftyJSON

class BusinessSearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: TextField!
    init(withTitle title: String) {
        super.init(nibName: "BusinessSearchViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
    }
    
    func setupTextField() {
        searchTextField.delegate = self
        searchTextField.setDefaultTextField()
    }

    @IBAction func searchAction(_ sender: Any) {
        searchForResults()
    }
    
    func searchForResults() {
        self.view.endEditing(true)
        if searchTextField.text?.trimmed != "" {
            searchBusiness()
        } else {
            searchTextField.setErroneousTextField(withErrorDetail: Constants.AppStrings.emptySearchTextFieldError)
        }
    }
    
    func searchBusiness() {
        businessRequestProvider.request(.getBusinesses(location: "Manila", term: searchTextField.text ?? "")) { (result) in
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

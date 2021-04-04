//
//  BusinessSearchResultViewController.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/2/21.
//

import UIKit
import SwiftyJSON

enum SortingCategory: Int, CaseIterable {
    case distanceNearFirst = 0
    case ratingHighFirst = 1
    case distanceFarFirst = 2
    case ratingLowFirst = 3
}

class BusinessSearchResultViewController: UIViewController {
    @IBOutlet weak var resultKeywordLabel: UILabel!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var resultsTable: UITableView!
    
    var businessesCellViewModels: [BusinessSearchResultCellViewModel] = []
    var businessResultsViewModel: BusinessSearchResultViewModel! {
        didSet {
            DispatchQueue.main.async {
                self.resultKeywordLabel?.text = self.businessResultsViewModel.resultsKeywordText
            }
            self.businessesCellViewModels = self.businessResultsViewModel.businesses.map({
                return BusinessSearchResultCellViewModel(business: $0)
            })
        }
    }
    var pickerDummyTextfield: UITextField!
    var pickerSelectedSort: SortingCategory!
    
    init(withTitle title: String) {
        super.init(nibName: "BusinessSearchResultViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultsTable.delegate = self
        self.resultsTable.dataSource = self
        let resultCellNib = UINib(nibName: "BusinessSearchResultCell", bundle: nil)
        self.resultsTable.register(resultCellNib, forCellReuseIdentifier: "BusinessSearchResultCell")
        let emptyResultCellNib = UINib(nibName: "EmptyResultCell", bundle: nil)
        self.resultsTable.register(emptyResultCellNib, forCellReuseIdentifier: "EmptyResultCell")
        self.resultsTable.reloadData()
        self.setInitialSortButton()
    }
    
    func seeBusinessDetails(id: String) {
        businessRequestProvider.request(.getBusinessDetails(id: id)) { (result) in
            switch result {
            case .success(let response):
                self.presentBusinessDetailsVC(response: JSON(response.data))
            case .failure:
                print("failed")
            }
        }
    }
    
    func setInitialSortButton() {
        if businessesCellViewModels.count == 0 {
            sortButton.isHidden = true
            sortButton.isEnabled = false
            return
        }
        self.sortResult(by: .distanceNearFirst)
    }
    
    func setSortButton(category: SortingCategory) {
        switch category {
        case .distanceFarFirst:
            self.sortButton.setTitle(Constants.AppStrings.sortButtonFarthestFirst, for: .normal)
        case .distanceNearFirst:
            self.sortButton.setTitle(Constants.AppStrings.sortButtonNearFirst, for: .normal)
        case .ratingLowFirst:
            self.sortButton.setTitle(Constants.AppStrings.sortButtonLowRatingFirst, for: .normal)
        case .ratingHighFirst:
            self.sortButton.setTitle(Constants.AppStrings.sortButtonHighRatingFirst, for: .normal)
        }
    }
    
    func presentBusinessDetailsVC(response: JSON) {
        let business = try? JSONDecoder().decode(Business.self, from: response.rawData())
        let businessDetailViewController = BusinessDetailViewController(withTitle: "Details")
        let businessDetailViewModel = BusinessDetailViewModel(business: business!)
        self.navigationController?.pushViewController(businessDetailViewController, animated: true)
        businessDetailViewController.businessDetailViewModel = businessDetailViewModel
    }
    
    func sortResult(by category: SortingCategory) {
        var sortedArray:[BusinessSearchResultCellViewModel] = []
        switch category {
        case .ratingHighFirst:
            sortedArray = self.businessesCellViewModels.sorted(by: { $0.ratingValue > $1.ratingValue })
        case .ratingLowFirst:
            sortedArray = self.businessesCellViewModels.sorted(by: { $0.ratingValue < $1.ratingValue })
        case .distanceNearFirst:
            sortedArray = self.businessesCellViewModels.sorted(by: { $0.distanceValue < $1.distanceValue })
        case .distanceFarFirst:
            sortedArray = self.businessesCellViewModels.sorted(by: { $0.distanceValue > $1.distanceValue })
        }
        self.businessesCellViewModels = []
        self.businessesCellViewModels = sortedArray
        self.setSortButton(category: category)
        self.resultsTable.reloadData()
        self.resultsTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    @IBAction func sortButtonAction(_ sender: Any) {
        let sortPicker = UIPickerView()
        sortPicker.delegate = self
        sortPicker.dataSource = self
        pickerDummyTextfield = UITextField(frame: CGRect.zero)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemPurple
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(pickerDone))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        view.addSubview(pickerDummyTextfield)
        pickerDummyTextfield.inputView = sortPicker
        pickerDummyTextfield.inputAccessoryView = toolBar
        pickerDummyTextfield.becomeFirstResponder()
    }
    
    @objc func pickerDone() {
        self.sortResult(by: self.pickerSelectedSort)
        pickerDummyTextfield.resignFirstResponder()
    }
}

extension BusinessSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businessesCellViewModels.count == 0 {
            tableView.bounces = false
            return 1
        }
        return businessesCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if businessesCellViewModels.count == 0 {
            let emptyCell = resultsTable.dequeueReusableCell(withIdentifier: "EmptyResultCell") as! EmptyResultCell
            return emptyCell
        }
        
        let businessCell = resultsTable.dequeueReusableCell(withIdentifier: "BusinessSearchResultCell") as! BusinessSearchResultCell
        businessCell.businessViewModel = businessesCellViewModels[indexPath.row]
        return businessCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if businessesCellViewModels.count > 0 {
            let businessId = businessesCellViewModels[indexPath.row].businessId
            self.seeBusinessDetails(id: businessId)
        }
    }
}


extension BusinessSearchResultViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SortingCategory.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch SortingCategory(rawValue: row) {
        case .ratingHighFirst:
            return Constants.AppStrings.sortOptionHighRatingFirst
        case .ratingLowFirst:
            return Constants.AppStrings.sortOptionLowRatingFirst
        case .distanceNearFirst:
            return Constants.AppStrings.sortOptionNearFirst
        case .distanceFarFirst:
            return Constants.AppStrings.sortOptionFarthestFirst
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = SortingCategory(rawValue: row)
        pickerSelectedSort = category
    }
}

//
//  BusinessSearchResultViewController.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/2/21.
//

import UIKit

class BusinessSearchResultViewController: UIViewController {
    @IBOutlet weak var resultKeywordLabel: UILabel!
    @IBOutlet weak var resultsTable: UITableView!
    
    var businessesCellViewModels: [BusinessSearchResultCellViewModel] = []
    var businessResultsViewModel: BusinessSearchResultViewModel! {
        didSet {
            resultKeywordLabel?.text = businessResultsViewModel.resultsKeywordText
            businessesCellViewModels = businessResultsViewModel.businesses.map({
                return BusinessSearchResultCellViewModel(business: $0)
            })
        }
    }
    
    init(withTitle title: String) {
        super.init(nibName: "BusinessSearchResultViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultKeywordLabel?.text = businessResultsViewModel.resultsKeywordText
        self.resultsTable.delegate = self
        self.resultsTable.dataSource = self
        let resultCellNib = UINib(nibName: "BusinessSearchResultCell", bundle: nil)
        self.resultsTable.register(resultCellNib, forCellReuseIdentifier: "BusinessSearchResultCell")
        let emptyResultCellNib = UINib(nibName: "EmptyResultCell", bundle: nil)
        self.resultsTable.register(emptyResultCellNib, forCellReuseIdentifier: "EmptyResultCell")
        self.resultsTable.reloadData()
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
}
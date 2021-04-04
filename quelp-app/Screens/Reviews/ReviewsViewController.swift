//
//  ReviewsViewController.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/4/21.
//

import UIKit

class ReviewsViewController: UIViewController {

    @IBOutlet weak var reviewsTable: UITableView!
    
    var reviewCellModels: [ReviewCellModel] = []
    var reviewsViewModel: ReviewsViewModel! {
        didSet {
            self.reviewCellModels = self.reviewsViewModel.reviews.map({
                return ReviewCellModel(review: $0)
            })
        }
    }
    
    init(withTitle title: String) {
        super.init(nibName: "ReviewsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewsTable.delegate = self
        self.reviewsTable.dataSource = self
        let reviewsCellNib = UINib(nibName: "ReviewCell", bundle: nil)
        self.reviewsTable.register(reviewsCellNib, forCellReuseIdentifier: "ReviewCell")
        self.reviewsTable.reloadData()
    }
}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewCellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTable.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
        cell.reviewCellModel = reviewCellModels[indexPath.row]
        return cell
    }
}

//
//  ViewController.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/1/21.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func testConnection(_ sender: Any) {
        businessRequestProvider.request(.getBusinesses(location: "kyoto")) { (result) in
            switch result {
            case .success:
                print("Successful")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}


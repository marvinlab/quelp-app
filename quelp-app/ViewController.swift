//
//  ViewController.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/1/21.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    var navCon: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let businessSearchScreen = BusinessSearchViewController(withTitle: "Search")
        navCon = UINavigationController(rootViewController: businessSearchScreen)
        navCon.view.frame.size = self.view.frame.size
        self.view.addSubview(navCon.view)
    }
}


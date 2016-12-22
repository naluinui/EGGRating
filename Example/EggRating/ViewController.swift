//
//  ViewController.swift
//  EggRating
//
//  Created by Somjintana K. on 12/21/2016.
//  Copyright (c) 2016 Somjintana K.. All rights reserved.
//

import UIKit
import EggRating

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        EggRating.showRateUsInView(viewController: self)
    }

    @IBAction func rateButtonTouched(_ sender: UIButton) {
        EggRating.showRateUsInView(viewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


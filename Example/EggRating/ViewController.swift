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
        EggRating.promptRateUsIfNeeded(viewController: self)
        EggRating.delegate = self
    }

    @IBAction func rateButtonTouched(_ sender: UIButton) {
        EggRating.promptRateUs(viewController: self)
    }
    
    @IBAction func rateIfNeedButtonTouched(_ sender: UIButton) {
        EggRating.promptRateUsIfNeeded(viewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: EggRatingDelegate {
    
    func didRate(rating: Double) {
        print("didRate: \(rating)")
    }
    
    func didRateOnAppStore() {
        print("didRateOnAppStore")
    }
    
    func didIgnoreToRate() {
        print("didIgnoreToRate")
    }
    
    func didIgnoreToRateOnAppStore() {
        print("didIgnoreToRateOnAppStore")
    }
}

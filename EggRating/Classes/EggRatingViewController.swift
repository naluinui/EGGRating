//
//  EggRatingViewController.swift
//  Pods
//
//  Created by Somjintana K. on 21/12/2016.
//
//

import UIKit
import RateView

class EggRatingViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var starContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public static func sendUserToAppStore() {
        
    }

}

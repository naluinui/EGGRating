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
        setupStarRateView()
    }
    
    func setupStarRateView() {
        
        let starContainerViewFrame = starContainerView.frame
        
        guard let starRateView = RateView(rating: 3.5) else {
            return
        }
        
        starRateView.step = 0.5
        starRateView.starSize = starContainerViewFrame.width/5.5
        starRateView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let frame = CGRect(x: (starContainerViewFrame.width - starRateView.frame.width)/2, y: starContainerViewFrame.height/2 - starRateView.frame.height/2, width: starContainerViewFrame.width, height: starContainerViewFrame.height)
        
        starRateView.frame = frame
        starContainerView.addSubview(starRateView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public static func sendUserToAppStore() {
        
    }

}

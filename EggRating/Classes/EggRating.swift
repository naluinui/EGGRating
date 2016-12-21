//
//  EggRating.swift
//  Pods
//
//  Created by Somjintana K. on 21/12/2016.
//
//

import UIKit

public class EggRating: NSObject {
    
    public static var itunesId = ""
    
    public static func showRateUsInView(viewController: UIViewController) {
        
        guard let rateViewController = rateViewFromNib as? EggRatingViewController else {
            return
        }
        
        rateViewController.view.frame = UIScreen.main.bounds
        rateViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        viewController.view.addSubview(rateViewController.view)
    }
    
    // MARK: - Helper
    
    private static var rateViewFromNib: UIViewController? {
        let podBundle = Bundle(for: EggRating.self)
        
        if let bundleURL = podBundle.url(forResource: "EggRating", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) {
            
            let nib = UINib(nibName: "EggRatingViewController", bundle: bundle)
            
            if let rateViewController = nib.instantiate(withOwner: self, options: nil)[0] as? EggRatingViewController {
                return rateViewController
            }
            
            return nil
            
        }
        
        return nil
    }
    
    // MARK: cache

}

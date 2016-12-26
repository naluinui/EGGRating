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
    
    public static var minRatingToAppStore = 4.0
    public static var daysUntilPrompt = 10
    
    // MARK: - Star Properties
    public static var starFillColor = UIColor(red: 255/255, green: 181/255, blue: 17/255, alpha: 1)
    public static var starNormalColor = UIColor.clear
    public static var starBorderColor = UIColor(red: 255/255, green: 181/255, blue: 17/255, alpha: 1)
    
    // MARK: - Button Properties
    public static var titleLabelText = "Rate This App"
    public static var descriptionLabelText = "If you love our app, please take a moment to rate it."
    public static var dismissButtonTitleText = "Not Now"
    public static var rateButtonTitleText = "Rate"
    
    public static var thankyouTitleLabelText = "Thank you!"
    public static var thankyouDescriptionLabelText = "Thank you for taking the time to provide us with your valuable feedback."
    public static var thankyouDismissButtonTitleText = "OK"
    
    public static var appStoreTitleLabelText = "Write a review on the App Store"
    public static var appStoreDescriptionLabelText = "Would you mind taking a moment to rate it on the App Store? It won't take more than a minute. Thanks for your support!"
    public static var appStoreDismissButtonTitleText = "Cancel"
    public static var appStoreRateButtonTitleText = "Rate It Now"
    
    public static var shouldPromptForRating: Bool {
        
        let daysFromLastRemind = Calendar.current.dateComponents([.day], from: lastRemind, to: Date()).day ?? 0
        
        if daysFromLastRemind < daysUntilPrompt {
            print("[EggRating] It's not the day until prompt yet.")
            return false
        }
        
        return true
    }

    public static func promptRateUsIfNeeded(viewController: UIViewController) {
        if shouldPromptForRating {
            self.promptRateUs(viewController: viewController)
        }
    }
    
    public static func promptRateUs(viewController: UIViewController) {
        
        if itunesId == "" {
            print("[EggRating] itunesId is required.")
            print("=> Please provide us your iTune ID by using EggRating.ituneId = \"YOUR-ITUNES-ID\" in AppDelegate.")
            return
        }
        
        guard let rateViewController = rateViewFromNib as? EggRatingViewController else {
            return
        }
        
        rateViewController.view.frame = UIScreen.main.bounds
        rateViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        viewController.addChildViewController(rateViewController)
        viewController.view.addSubview(rateViewController.view)
        rateViewController.didMove(toParentViewController: viewController)
    }
    
    // MARK: - Helper
    
    // MARK: - View
    
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
    
    fileprivate static let userDefaults = UserDefaults.standard
    
    fileprivate static var lastRemind: Date {
        set(date) {
            userDefaults.set(date, forKey: EggRatingUserDefaultsKey.lastRemindKey.rawValue)
        } get {
            
            guard let lastOpenDate = userDefaults.object(forKey: EggRatingUserDefaultsKey.lastRemindKey.rawValue) as? Date else {
                let today = Date()
                userDefaults.set(today, forKey: EggRatingUserDefaultsKey.lastRemindKey.rawValue)
                return today
            }
            
            return lastOpenDate
        }
    }
}

enum EggRatingUserDefaultsKey: String {
    case lastRemindKey = "EggRatingLastRemind"
}

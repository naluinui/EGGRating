//
//  EggRating.swift
//  Pods
//
//  Created by Somjintana K. on 21/12/2016.
//
//

import UIKit

public class EggRating: NSObject {
    
    public static var delegate: EggRatingDelegate?
    
    public static var itunesId = ""
    
    public static var minRatingToAppStore = 4.0
    
    public static var daysUntilPrompt = 10
    
    public static var remindPeriod = 10
    
    fileprivate static let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    
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
        
        let daysFromFirstUsed = Calendar.current.dateComponents([.day], from: firstUsed, to: Date()).day ?? 0
        let daysFromLastRemind = Calendar.current.dateComponents([.day], from: lastRemind, to: Date()).day ?? 0
        
        if daysFromFirstUsed < daysUntilPrompt {
            print("[EggRating] User has just used the app for only \(daysFromLastRemind) \(daysFromLastRemind <= 1 ? "day" : "days"). EggRating will be prompted in the next \(daysUntilPrompt - daysFromLastRemind) \(daysUntilPrompt - daysFromLastRemind <= 1 ? "day" : "days").")
            return false
        }
        
        print("currentVersion: \(currentVersion) lastVersionRated: \(lastVersionRated)")
        
        if versionToInt(string: currentVersion).lexicographicallyPrecedes(versionToInt(string: lastVersionRated)) {
            return true
        } else if currentVersion == lastVersionRated {
            print("[EggRating] User has already rated this version.")
            return false
        }
        
        if daysFromLastRemind < remindPeriod {
            print("[EggRating] EggRating was just prompted last \(daysFromLastRemind) \(daysFromLastRemind <= 1 ? "day" : "days") ago. EggRating will be prompted again in the next \(remindPeriod - daysFromLastRemind) \(remindPeriod - daysFromLastRemind <= 1 ? "day" : "days").")
            return false
        }
        
        return true
    }

    public static func promptRateUsIfNeeded(viewController: UIViewController) {
        if shouldPromptForRating {
            self.promptRateUs(viewController: viewController)
            lastRemind = Date()
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
    
    // MARK: View
    
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
    
    // MARK: Version
    fileprivate static func versionToInt(string: String) -> [Int] {
        return string.components(separatedBy: ".").map { Int.init($0) ?? 0 }
    }
    
    // MARK: Cache
    
    fileprivate static let userDefaults = UserDefaults.standard
    
    fileprivate static var firstUsed: Date {
        set (date) {
            userDefaults.set(date, forKey: EggRatingUserDefaultsKey.firstUsedKey.rawValue)
        } get {
            guard let firstUsedDate = userDefaults.object(forKey: EggRatingUserDefaultsKey.firstUsedKey.rawValue) as? Date else {
                let today = Date()
                userDefaults.set(today, forKey: EggRatingUserDefaultsKey.firstUsedKey.rawValue)
                return today
            }
            
            return firstUsedDate
        }
    }
    
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
    
    fileprivate static var lastVersionRated: String {
        set(version) {
            userDefaults.set(version, forKey: EggRatingUserDefaultsKey.lastVersionRatedKey.rawValue)
        } get {
            return userDefaults.string(forKey: EggRatingUserDefaultsKey.lastVersionRatedKey.rawValue) ?? "0.0.0"
        }
    }
}

enum EggRatingUserDefaultsKey: String {
    case firstUsedKey = "EggRatingFirstUsed"
    case lastRemindKey = "EggRatingLastRemind"
    case lastVersionRatedKey = "EggRatingLastVersionRated"
}

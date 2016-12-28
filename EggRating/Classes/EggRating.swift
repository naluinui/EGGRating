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
    
    public static let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    
    // MARK: - Debugging Properties
    
    public static var debugMode = false {
        didSet {
            if debugMode {
                print("[EggRating] ‼️ Debug mode is now on. Don't forget to set it back to be 'false' before uploading to the App Store.")
            }
        }
    }
    
    fileprivate static var _minuteUntilPrompt = 0
    
    public static var minuteUntilPrompt: Int {
        set(minute) {
            _minuteUntilPrompt = minute
        } get {
            return debugMode ? _minuteUntilPrompt : daysUntilPrompt * 60 * 24
        }
    }
    
    fileprivate static var _minuteRemindPeriod = 0
    
    public static var minuteRemindPeriod: Int {
        set(minute) {
            _minuteRemindPeriod = minute
        } get {
            return debugMode ? _minuteRemindPeriod : remindPeriod * 60 * 24
        }
    }
    
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
    
    // MARK: - Main Methods
    
    public static var shouldPromptForRating: Bool {
        
        let minutesFromFirstUsed = Calendar.current.dateComponents([.minute], from: firstUsed, to: Date()).minute ?? 0
        let minutesFromLastRemind = Calendar.current.dateComponents([.minute], from: lastRemind, to: Date()).minute ?? 0
        
        if minutesFromFirstUsed < minuteUntilPrompt {
            print("[EggRating] 🕑 User has just used the app for only \(minutesFromLastRemind) \(minutesFromLastRemind <= 1 ? "minute" : "minutes"). EggRating will be prompted in the next \(minuteUntilPrompt - minutesFromLastRemind) \(minuteUntilPrompt - minutesFromLastRemind <= 1 ? "minute" : "minutes").")
            return false
        }
        
        if versionToInt(string: currentAppVersion).lexicographicallyPrecedes(versionToInt(string: lastVersionRated)) {
            return true
        } else if currentAppVersion == lastVersionRated {
            print("[EggRating] 🙂 User has already rated this version.")
            return false
        }
        
        if minutesFromLastRemind < minuteRemindPeriod {
            print("[EggRating] 🕙 EggRating was just prompted last \(minutesFromLastRemind) \(minutesFromLastRemind <= 1 ? "minute" : "minutes") ago. EggRating will be prompted again in the next \(minuteRemindPeriod - minutesFromLastRemind) \(remindPeriod - minutesFromLastRemind <= 1 ? "minute" : "minutes").")
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
            print("[EggRating] ‼️ itunesId is required.")
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
    
    public static private(set) var firstUsed: Date {
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
    
    public static private(set) var lastRemind: Date {
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
    
    public static private(set) var lastVersionRated: String {
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

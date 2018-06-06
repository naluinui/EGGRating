//
//  EggRating.swift
//  Pods
//
//  Created by Somjintana K. on 21/12/2016.
//
//

import UIKit

public class EggRating: NSObject {
    
    /// The iTunes ID of the application. This field is required to bring the user to the App Store.
    @objc public static var itunesId = ""
    
    /// The minimum score to bring user to rate on the App Store.
    @objc public static var minRatingToAppStore = 4.0
    
    /// The condition to show alert dialog after user rated poor score.
    @objc public static var shouldShowThankYouAlertController = true
    
    /// The condition to show EggRatingView after first time user start using the application, default is 10 days. This will be used only when debug mode is off.
    @objc public static var daysUntilPrompt = 10 {
        didSet {
            if daysUntilPrompt == 0 {
                daysUntilPrompt = 10
                print("[EggRating] ‼️ Days until prompt shouldn't be 0.")
            }
        }
    }
    
    /// The condition to remind the user to rate the application again, default is 10 days. This will be used only when debug mode is off.
    @objc public static var remindPeriod = 10 {
        didSet {
            if remindPeriod == 0 {
                remindPeriod = 10
                print("[EggRating] ‼️ Remind period shouldn't be 0.")
            }
        }
    }
    
    /// The protocol of the actions in EggRatingView. Assign this value in viewDidLoad of UIViewController which you want to show EggRatingView before calling promptRateUsIfNeeded(viewController: UIViewController) or promptRateUs(viewController: UIViewController) functions.
    @objc public static var delegate: EggRatingDelegate?
    
    /// The current application version.
    @objc public static let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    
    // MARK: - Debugging Properties
    
    /// The debug mode, default is false.
    @objc public static var debugMode = false {
        didSet {
            if debugMode {
                print("[EggRating] ‼️ Debug mode is now on. Don't forget to set it back to be 'false' before uploading to the App Store.")
            }
        }
    }
    
    /// The condition to show EggRatingView after first time user start using the application in minute. You can set and get the value you want only when debug mode is on. If debug mode is off, this will return the daysUntilPrompt in minutes.

    @objc public static var minuteUntilPrompt: Int {
        set(minute) {
            _minuteUntilPrompt = minute
        } get {
            return debugMode ? _minuteUntilPrompt : daysUntilPrompt * 60 * 24
        }
    }
    
    fileprivate static var _minuteUntilPrompt = 0
    
    /// The condition to remind the user to rate the application again. You can set and get the value you want only when debug mode is on. If debug mode is off, this will return the remindPeriod in minutes.
    
    @objc public static var minuteRemindPeriod: Int {
        set(minute) {
            _minuteRemindPeriod = minute
        } get {
            return debugMode ? _minuteRemindPeriod : remindPeriod * 60 * 24
        }
    }
    
    fileprivate static var _minuteRemindPeriod = 0
    
    /// The application version property, You can set and get the value you want only when debug mode is on. If debug mode is off, this will return the current version of the application which is in the bundle directory.
    
    @objc public static var appVersion: String {
        set(version) {
            _appVersion = version
        } get {
            return debugMode ? _appVersion : currentAppVersion
        }
    }
    
    fileprivate static var _appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    
    // MARK: - Star Properties
    
    /// The color of selected stars, default is yellow.
    @objc public static var starFillColor = UIColor(red: 255/255, green: 181/255, blue: 17/255, alpha: 1)
    
    /// The color of normal stars, default is clear.
    @objc public static var starNormalColor = UIColor.clear
    
    /// The color of star border, default is yellow.
    @objc public static var starBorderColor = UIColor(red: 255/255, green: 181/255, blue: 17/255, alpha: 1)
    
    // MARK: - Button Properties
    
    /// The title of EggRatingView.
    @objc public static var titleLabelText = "Rate This App"
    
    /// The description of EggRatingView.
    @objc public static var descriptionLabelText = "If you love our app, please take a moment to rate it."
    
    /// The dismiss button title of EggRatingView.
    @objc public static var dismissButtonTitleText = "Not Now"
    
    /// The rate button title of EggRatingView.
    @objc public static var rateButtonTitleText = "Rate"
    
    /// The thank you title of EggRatingView.
    @objc public static var thankyouTitleLabelText = "Thank you!"
    
    /// The thank you description of EggRatingView.
    @objc public static var thankyouDescriptionLabelText = "Thank you for taking the time to provide us with your valuable feedback."
    
    /// The thank you dismiss button of EggRatingView.
    @objc public static var thankyouDismissButtonTitleText = "OK"
    
    /// The rate on app store title of EggRatingView.
    @objc public static var appStoreTitleLabelText = "Write a review on the App Store"
    
    /// The rate on app store description of EggRatingView.
    @objc public static var appStoreDescriptionLabelText = "Would you mind taking a moment to rate it on the App Store? It won't take more than a minute. Thanks for your support!"
   
    /// The rate on app store dismiss button title of EggRatingView.
    @objc public static var appStoreDismissButtonTitleText = "Cancel"
    
    /// The rate on app store rate button title of EggRatingView.
    @objc public static var appStoreRateButtonTitleText = "Rate It Now"
    
    // MARK: - Main Methods
    
    /// The condition to show EggRatingView included: minutesFromFirstUsed, applicationVersion, minutesFromLastRemind.
    @objc public static var shouldPromptForRating: Bool {
        
        let minutesFromFirstUsed = Calendar.current.dateComponents([.minute], from: firstUsed, to: Date()).minute ?? 0
        let minutesFromLastRemind = Calendar.current.dateComponents([.minute], from: lastRemind, to: Date()).minute ?? 0
        
        if minutesFromFirstUsed < minuteUntilPrompt {
            print("[EggRating] 🕑 User has just used the app for only \(minutesFromLastRemind) \(minutesFromLastRemind <= 1 ? "minute" : "minutes"). EggRating will be prompted in the next \(minuteUntilPrompt - minutesFromLastRemind) \(minuteUntilPrompt - minutesFromLastRemind <= 1 ? "minute" : "minutes").")
            return false
        }
        
        if versionToInt(string: appVersion).lexicographicallyPrecedes(versionToInt(string: lastVersionRated)) {
            return true
        } else if appVersion == lastVersionRated {
            print("[EggRating] 🙂 User has already rated this version.")
            return false
        }
        
        if minutesFromLastRemind < minuteRemindPeriod {
            print("[EggRating] 🕙 EggRating was just prompted last \(minutesFromLastRemind) \(minutesFromLastRemind <= 1 ? "minute" : "minutes") ago. EggRating will be prompted again in the next \(minuteRemindPeriod - minutesFromLastRemind) \(remindPeriod - minutesFromLastRemind <= 1 ? "minute" : "minutes").")
            return false
        }

        return true
    }
    
    /**
     Show RateUsView with the condition.
     - parameter viewController: The view controller to show RateUsView
     */

    @objc public static func promptRateUsIfNeeded(in viewController: UIViewController) {
        if shouldPromptForRating {
            self.promptRateUs(in: viewController)
            lastRemind = Date()
        }
    }
    
    /**
     Show RateUsView immediately.
     - parameter viewController: The view controller to show RateUsView
     */
    
    @objc public static func promptRateUs(in viewController: UIViewController) {
        
        if itunesId == "" {
            print("[EggRating] ‼️ itunesId is required.")
            print("=> Please provide us your iTune ID by using EggRating.ituneId = \"YOUR-ITUNES-ID\" in AppDelegate.")
            return
        }
        
        guard let rateViewController = rateViewFromNib as? EggRatingViewController else {
            return
        }
        
        if #available(iOS 8.0, *) {
            rateViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            rateViewController.providesPresentationContextTransitionStyle = true
            rateViewController.definesPresentationContext = true
        } else {
            rateViewController.modalPresentationStyle = UIModalPresentationStyle.currentContext
        }
        
        if let tabbarController = viewController.tabBarController {
            tabbarController.present(rateViewController, animated: false, completion: nil)
        } else if let navigationController = viewController.navigationController {
            navigationController.present(rateViewController, animated: false, completion: nil)
        } else {
            viewController.present(rateViewController, animated: false, completion: nil)
        }
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
    
    /// The day user starts using the application.
    
    @objc public static private(set) var firstUsed: Date {
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
    
    /// The last day EggRatingView is reminded.
    
    @objc public static private(set) var lastRemind: Date {
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
    
    /// The latest application version which user has rated.
    
    @objc public static private(set) var lastVersionRated: String {
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

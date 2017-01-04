//
//  SettingTableViewController.swift
//  EggRating
//
//  Created by Somjintana K. on 28/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import EggRating

enum SettingType {
    case appVersion
    case daysUntilPrompt
    case daysRemindPeriod
    case minutesUntilPrompt
    case minitesRemindPeriod
    case minimumScore
}

class SettingTableViewController: UITableViewController {
    
    var type: SettingType?
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        guard let type = type else {
            return
        }

        switch type {
        case .appVersion:
            self.title = "App version"
            self.textField.text = "\(EggRating.appVersion)"
            self.textField.keyboardType = .decimalPad
        case .daysUntilPrompt:
            self.title = "Day until prompt"
            self.textField.text = "\(EggRating.daysUntilPrompt)"
        case .daysRemindPeriod:
            self.title = "Remind period"
            self.textField.text = "\(EggRating.remindPeriod)"
        case .minutesUntilPrompt:
            self.title = "Minute until prompt"
            self.textField.text = "\(EggRating.minuteUntilPrompt)"
        case .minitesRemindPeriod:
            self.title = "Minute remind period"
            self.textField.text = "\(EggRating.minuteRemindPeriod)"
        case .minimumScore:
            self.title = "Minimum score"
            self.textField.text = "\(EggRating.minRatingToAppStore)"
            self.textField.keyboardType = .decimalPad
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let type = type, let value = textField.text else {
            return
        }
        
        switch type {
        case .appVersion:
            EggRating.appVersion = value
        case .daysUntilPrompt:
            EggRating.daysUntilPrompt = Int(value) ?? 0
        case .daysRemindPeriod:
            EggRating.remindPeriod = Int(value) ?? 0
        case .minutesUntilPrompt:
            EggRating.minuteUntilPrompt = Int(value) ?? 0
        case .minitesRemindPeriod:
            EggRating.minuteRemindPeriod = Int(value) ?? 0
        case .minimumScore:
            EggRating.minRatingToAppStore = Double(value) ?? 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SettingTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let type = type, type == .minimumScore {
            if let value = textField.text {
                if Double(value + string) ?? 0 > 5 {
                    return false
                }
            }
            return true
        }
        
        return true
    }
}

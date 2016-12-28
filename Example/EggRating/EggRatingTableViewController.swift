//
//  EggRatingTableViewController.swift
//  EggRating
//
//  Created by Somjintana K. on 28/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import EggRating

class EggRatingTableViewController: UITableViewController {

    @IBOutlet weak var debugModeSwitch: UISwitch!
    @IBOutlet weak var minuteUntilPromptLabel: UILabel!
    @IBOutlet weak var dayUntilPromptLabel: UILabel!
    @IBOutlet weak var minuteRemindPeriodLabel: UILabel!
    @IBOutlet weak var dayRemindPeriodLabel: UILabel!
    @IBOutlet weak var currentRatedVersionLabel: UILabel!
    @IBOutlet weak var lastestRateVersionLabel: UILabel!
    @IBOutlet weak var firstDateUsingAppLabel: UILabel!
    @IBOutlet weak var latestRemindDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        debugModeSwitch.isOn = EggRating.debugMode
        minuteUntilPromptLabel.text = "\(EggRating.minuteUntilPrompt)"
        dayUntilPromptLabel.text = "\(EggRating.daysUntilPrompt)"
        minuteRemindPeriodLabel.text = "\(EggRating.minuteRemindPeriod)"
        dayRemindPeriodLabel.text = "\(EggRating.remindPeriod)"
        
        currentRatedVersionLabel.text = "\(EggRating.currentAppVersion)"
        lastestRateVersionLabel.text = "\(EggRating.lastVersionRated)"
        firstDateUsingAppLabel.text = "\(EggRating.firstUsed)"
        latestRemindDateLabel.text = "\(EggRating.lastRemind)"
        
        dayUntilPromptLabel.textColor = !EggRating.debugMode ? UIColor.black : UIColor.gray
        dayRemindPeriodLabel.textColor = !EggRating.debugMode ? UIColor.black : UIColor.gray
        minuteRemindPeriodLabel.textColor = EggRating.debugMode ? UIColor.black : UIColor.gray
        minuteUntilPromptLabel.textColor = EggRating.debugMode ? UIColor.black :UIColor.gray
    }
    
    // MARK: - Action
    
    @IBAction func rateNowButtonTouched(_ sender: UIButton) {
        EggRating.promptRateUs(viewController: self)
    }
    
    @IBAction func rateWithConditionButtonTouched(_ sender: UIButton) {
        EggRating.promptRateUsIfNeeded(viewController: self)
    }
    
    @IBAction func debugModeValueChanged(_ sender: UISwitch) {
        EggRating.debugMode = sender.isOn
        setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 1:
                if !EggRating.debugMode {
                    pushToEditVC(identifier: .daysUntilPrompt)
                }
            case 2:
                if !EggRating.debugMode {
                    pushToEditVC(identifier: .daysRemindPeriod)
                }
            case 3:
                if EggRating.debugMode {
                    pushToEditVC(identifier: .minutesUntilPrompt)
                }
            case 4:
                if EggRating.debugMode {
                    pushToEditVC(identifier: .minitesRemindPeriod)
                }
            default:
                break
            }
        }
    }
    
    func pushToEditVC(identifier: SettingType) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingTableViewController") as? SettingTableViewController else {
            return
        }
        vc.type = identifier
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

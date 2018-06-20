//
//  EggRatingViewController.swift
//  Pods
//
//  Created by Somjintana K. on 21/12/2016.
//
//

import UIKit
import RateView

/// The protocol of the actions in EggRatingView.

@objc public protocol EggRatingDelegate {
    func didRate(rating rate: Double)
    func didIgnoreToRate()
    func didRateOnAppStore()
    func didIgnoreToRateOnAppStore()
    func didDissmissThankYouDialog()
}

class EggRatingViewController: UIViewController {
    
    fileprivate let delegate = EggRating.delegate
    
    fileprivate var rating: Double = 0.0 {
        didSet {
            self.rateButton.setTitleColor(rating > 0.0 ? defaultTintColor : UIColor.gray, for: .normal)
            self.rateButton.isEnabled = rating > 0.0
        }
    }
    
    fileprivate let defaultTintColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0)

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var starContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        rating = 0.0
    }
    
    func setupView() {
        containerView.layer.cornerRadius = 10
        
        setupStarRateView()
        
        titleLabel.text = EggRating.titleLabelText
        descriptionLabel.text = EggRating.descriptionLabelText
        
        cancelButton.setTitle(EggRating.dismissButtonTitleText, for: .normal)
        cancelButton.setTitleColor(defaultTintColor, for: .normal)
        
        rateButton.setTitle(EggRating.rateButtonTitleText, for: .normal)
        rateButton.setTitleColor(defaultTintColor, for: .normal)
    }
    
    func setupStarRateView() {
        
        let starContainerViewFrame = starContainerView.frame
        
        guard let starRateView = RateView(rating: 0) else {
            return
        }
        
        starRateView.canRate = true
        starRateView.delegate = self
        starRateView.starFillColor = EggRating.starFillColor
        starRateView.starBorderColor = EggRating.starBorderColor
        starRateView.starNormalColor = EggRating.starNormalColor
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
    
    func sendUserToAppStore() {
        
        guard let url = URL(string: "itms-apps://itunes.apple.com/us/app/itunes-u/id\(EggRating.itunesId)?ls=1&mt=8&action=write-review") else {
            return
        }
        
        UIApplication.shared.openURL(url)
        
        delegate?.didRateOnAppStore()
    }
    
    // MARK: - Action

    @IBAction func cancelButtonTouched(_ sender: UIButton) {
        self.view.backgroundColor = UIColor.clear
        self.containerView.isHidden = true
        self.delegate?.didIgnoreToRate()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func rateButtonTouched(_ sender: UIButton) {
        self.view.backgroundColor = UIColor.clear
        self.containerView.isHidden = true
        
        let minRatingToAppStore = EggRating.minRatingToAppStore > 5 ? 5 : EggRating.minRatingToAppStore
        
        if rating >= minRatingToAppStore {
            showRateInAppStoreAlertController()
            
            // only save last rated version if user rates more than mininum score
            UserDefaults.standard.set(EggRating.appVersion, forKey: EggRatingUserDefaultsKey.lastVersionRatedKey.rawValue)
            
        } else {
            showThankyouAlertController()
        }
        
        delegate?.didRate(rating: rating)
    }
    
    // MARK: Alert
    
    func showThankyouAlertController() {
        
        if !EggRating.shouldShowThankYouAlertController { return }
        
        let disadvantageAlertController = UIAlertController(title: EggRating.thankyouTitleLabelText, message: EggRating.thankyouDescriptionLabelText, preferredStyle: .alert)
        
        disadvantageAlertController.addAction(UIAlertAction(title: EggRating.thankyouDismissButtonTitleText, style: .default, handler: { (_) in
            self.delegate?.didDissmissThankYouDialog()
            self.dismiss(animated: false, completion: nil)
        }))
        
        self.present(disadvantageAlertController, animated: true, completion: nil)
    }
    
    func showRateInAppStoreAlertController() {
        
        let rateInAppStoreAlertController = UIAlertController(title: EggRating.appStoreTitleLabelText, message: EggRating.appStoreDescriptionLabelText, preferredStyle: .alert)
        
        rateInAppStoreAlertController.addAction(UIAlertAction(title: EggRating.appStoreDismissButtonTitleText, style: .default, handler: { (_) in
            self.dismiss(animated: false, completion: nil)
            self.delegate?.didIgnoreToRateOnAppStore()
        }))
        
        rateInAppStoreAlertController.addAction(UIAlertAction(title: EggRating.appStoreRateButtonTitleText, style: .default, handler: { (_) in
            self.sendUserToAppStore()
            self.dismiss(animated: false, completion: nil)
        }))
        
        self.present(rateInAppStoreAlertController, animated: true, completion: nil)
    }
    
}

extension EggRatingViewController: RateViewDelegate {
    
    func rateView(_ rateView: RateView!, didUpdateRating rating: Float) {
        let celiRating = String(format: "%.2f", rating)
        self.rating = Double(celiRating) ?? Double(rating)
    }
}

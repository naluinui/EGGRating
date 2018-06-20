# EggRating
Let's increase your iOS app reviews with `EggRating`.

[![Version](https://img.shields.io/cocoapods/v/EggRating.svg?style=flat)](http://cocoapods.org/pods/EggRating)
[![License](https://img.shields.io/cocoapods/l/EggRating.svg?style=flat)](http://cocoapods.org/pods/EggRating)
[![Platform](https://img.shields.io/cocoapods/p/EggRating.svg?style=flat)](http://cocoapods.org/pods/EggRating)

`EggRating` is an iOS app review tool written in Swift. `EggRating` will prompt users to rate the app after they have used it a certain number of times or after a set time period. If the user rates more than a certain number, `EggRating` will take them right to the app store where they can leave their good review 😉👍 

![Screenshots](https://cloud.githubusercontent.com/assets/9149523/21676989/bf9cb586-d36a-11e6-81b7-e6f499f2d0d5.png)

## Requirements

- iOS 8.0+
- Swift 3.0+

## Installation

EggRating is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EggRating'
```

## Usage

1., Import `EggRating` in `AppDelegate` file and in `application:didFinishLaunchingWithOptions:` initialize `EggRating` with your itunesId and other properties you want to customize

```swift
EggRating.itunesId = "123456789"
EggRating.minRatingToAppStore = 3.5
```

2., Import `EggRating` in view controller file:

```swift
import EggRating
```

3., Use the following to display the `EggRating` automatically (with the conditions):

```swift
EggRating.promptRateUsIfNeeded(in: self)
```

4., To show an `EggRating` immediately:

```swift
EggRating.promptRateUs(in: self)
```

5., To access `EggRating` protocol, implement `EggRatingDelegate`:

```swift
EggRating.delegate = self
```

```swift
extension ViewController: EggRatingDelegate {
    
    func didRate(rating: Double) {
        print("didRate: \(rating)")
    }
    
    func didRateOnAppStore() {
        print("didRateOnAppStore")
    }
    
    func didIgnoreToRate() {
        print("didIgnoreToRate")
    }
    
    func didIgnoreToRateOnAppStore() {
        print("didIgnoreToRateOnAppStore")
    }
    
    func didDissmissThankYouDialog() {
        print("didDissmissThankYouDialog")
    }
}
```
## Customisation

`EggRating` also provides a property set for a customization usage:

- `itunesId` : The iTunes ID of the application (required).

- `delegate` : Register in order to listen to rating actions.

- `minRatingToAppStore` : Minimum score to bring user to review on the App Store, default is 4.0.

- `daysUntilPrompt` : A certain number of times to display `EggRating` after first used date, default is 10 days.

- `remindPeriod` : A certain number of times to display `EggRating` again, default is 10 days.

- `starFillColor` : The color of selected stars, default is yellow.

- `starNormalColor` : The color of normal stars, default is clear.

- `starBorderColor` : The color of star border, default is yellow.

- `titleLabelText` : The title of `EggRating` dialog.

- `descriptionLabelText` : The description of `EggRating` dialog.

- `dismissButtonTitleText` : The dismiss button title of `EggRating` dialog.

- `rateButtonTitleText` : The rate button title of `EggRating` dialog.

- `thankyouTitleLabelText` : The thank you title.

- `thankyouDescriptionLabelText` : The thank you description.

- `thankyouDismissButtonTitleText` : The thank you dismiss button.

- `appStoreTitleLabelText` : The rate on app store title.

- `appStoreDescriptionLabelText` : The rate on app store description.

- `appStoreDismissButtonTitleText` : The rate on app store dismiss button title.

- `appStoreRateButtonTitleText` : The rate on app store rate button title.

- `debugMode` : The debug mode, default is false.

- `minuteUntilPrompt` : A certain number of times to display `EggRating` after first used date in minute. This can be set only when debug mode is on.
    
- `minuteRemindPeriod` : A certain number of times to display `EggRating` again in minute. This can be set only when debug mode is on.

- `appVersion` : The application version. This can be set only when debug mode is on.

- `shouldShowThankYouAlertController` : The condition to show thank you alert dialog after user rated poor score.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Credits
- The rating stars are from [RateView](https://github.com/taruntyagi697/RateView).
- The star in the App Icon of an example project is made by [Maxim Basinski](http://www.flaticon.com/authors/maxim-basinski) from www.flaticon.com

## License

EggRating is available under the MIT license. See the LICENSE file for more info.

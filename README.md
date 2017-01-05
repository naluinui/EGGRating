# EggRating
Let's increase your iOS app reviews with `EggRating`.

[![CI Status](http://img.shields.io/travis/Somjintana K./EggRating.svg?style=flat)](https://travis-ci.org/Somjintana K./EggRating)
[![Version](https://img.shields.io/cocoapods/v/EggRating.svg?style=flat)](http://cocoapods.org/pods/EggRating)
[![License](https://img.shields.io/cocoapods/l/EggRating.svg?style=flat)](http://cocoapods.org/pods/EggRating)
[![Platform](https://img.shields.io/cocoapods/p/EggRating.svg?style=flat)](http://cocoapods.org/pods/EggRating)

`EggRating` is an iOS app review tool written in Swift. `EggRating` will prompt users to rate the app after they have used it a certain number of times or after a set time period. If the user rates more than a certain number, `EggRating` will take them right to the app store where they can leave their good review 😉👍 

![Screenshots](https://cloud.githubusercontent.com/assets/9149523/21668934/8649721e-d339-11e6-8d48-49d4cbb88fe0.png)

## Requirements

- iOS 8.0+

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
EggRating.promptRateUsIfNeeded(viewController: self)
```

4., To show an `EggRating` immediately:

```swift
EggRating.promptRateUs(viewController: self)
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
}
```

## Credits
The rating stars are from [RateView](https://github.com/taruntyagi697/RateView). <br>
The star in the App Icon of an example project is made by [Maxim Basinski](http://www.flaticon.com/authors/maxim-basinski) from www.flaticon.com

## License

EggRating is available under the MIT license. See the LICENSE file for more info.

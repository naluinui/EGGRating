#
# Be sure to run `pod lib lint EggRating.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EggRating'
  s.version          = '0.1.3'
  s.summary          = 'An iOS app review tool for getting only good reviews in the App Store!'

  s.description      = <<-DESC
Increase your iOS app reviews with EggRating. EggRating will prompt users to rate the app after they have used it a certain number of times or after a set time period. If the user rates more than a certain number, EggRating will take them right to the app store where they can leave their good review.
                       DESC

  s.homepage         = 'https://github.com/naluinui/EggRating'
  s.screenshots     = 'https://cloud.githubusercontent.com/assets/9149523/21676989/bf9cb586-d36a-11e6-81b7-e6f499f2d0d5.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Somjintana K.' => 'nuisomjin@gmail.com' }
  s.source           = { :git => 'https://github.com/naluinui/EggRating.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'EggRating/Classes/**/*'

  s.resource_bundles = {
    'EggRating' => ['EggRating/Assets/**/*.xib']
  }

  s.dependency 'RateView'
end

#
# Be sure to run `pod lib lint KDSocialLoginManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KDSocialLoginManager'
  s.version          = '0.1.1'
  s.summary          = 'A short description of KDSocialLoginManager.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'POC : This repository holds the social login in iOS with multiple platforms and multiple schemes of login using OAuth 2.0 as well as login with Facebook, LinkedIn, Google directly. One can directly leverage framework as ready reckoner to support multiple social login on any platform.'

  s.homepage         = 'https://github.com/kuldeepbhatt/KDSocialLoginManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kuldeepbhatt' => 'bhatt.it2010@gmail.com' }
  s.source           = { :git => 'https://github.com/kuldeepbhatt/KDSocialLoginManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'KDSocialLoginManager/Classes/**/*'

  s.xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'AppAuth'
  s.dependency 'UICKeyChainStore', '~> 2.1.2'
  s.dependency 'Alamofire', '~> 4.0'
  s.dependency 'FacebookCore'
  s.dependency 'FacebookLogin'
  s.dependency 'FacebookShare'
  s.dependency 'GoogleSignIn'
end

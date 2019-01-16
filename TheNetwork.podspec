#
# Be sure to run `pod lib lint TheNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TheNetwork'
  s.version          = '0.1.0'
  s.summary          = '对网络层进行隔离，保持对业务层网络请求行为一致。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
通过实现协议在数据请求后对回调进行调用，就可以在业务层中实现更换三方网络请求框架而不更改业务层代码。
                       DESC

  s.homepage         = 'https://github.com/DacianSky/TheNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DacianSky' => 'sdqvsqiu@gmail.com' }
  s.source           = { :git => 'https://github.com/DacianSky/TheNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TheNetwork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TheNetwork' => ['TheNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

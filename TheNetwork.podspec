# Be sure to run `pod lib lint TheNetwork.podspec' to ensure this is a valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'TheNetwork'
  s.version          = '0.9.3'
  s.summary          = '对网络层进行隔离，保持对业务层网络请求行为一致。'


  s.description      = <<-DESC
通过实现协议在数据请求后对回调进行调用，就可以在业务层中实现更换三方网络请求框架而不更改业务层代码。
                       DESC

  s.homepage         = 'https://github.com/DacianSky/TheNetwork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'TheMe' => 'sdqvsqiu@gmail.com' }
  s.source           = { :git => 'https://github.com/DacianSky/TheNetwork.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'TheNetwork/Classes/**/*'
  
end

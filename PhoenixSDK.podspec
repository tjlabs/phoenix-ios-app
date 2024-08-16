
Pod::Spec.new do |s|
  s.name             = 'PhoenixSDK'
  s.version          = '0.0.1'
  s.summary          = 'PhoenixSDK for iOS'
  s.swift_version    = '5.0'
  
  s.ios.deployment_target = '15.0'
  
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://www.tjlabscorp.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tjlabs-dev' => 'dev@tjlabscorp.com' }
  s.source           = { :git => 'https://github.com/tjlabs/phoenix-ios-app.git', :tag => s.version.to_s }

  

  s.source_files = 'PhoenixSDK/Classes/**/*'
  s.static_framework = true
  
end

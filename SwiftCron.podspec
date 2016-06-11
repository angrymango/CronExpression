Pod::Spec.new do |s|
  s.name             = "SwiftCron"
  s.version          = "0.3.6"
  s.summary          = "Cron expression parser."


  s.description      = <<-DESC
A cron expression parser written in Swift that can take a cron string and give you the next run date and time specified in the string.
                       DESC

  s.homepage         = "https://github.com/Rush42/SwiftCron"
  s.license          = 'MIT'
  s.author           = { "Keegan Rush" => "galaxyplansoftware@gmail.com" }
  s.source           = { :git => "https://github.com/Rush42/SwiftCron.git", :tag => "#{s.version}" }
  s.social_media_url = 'https://twitter.com/RushKeegan'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SwiftCron/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SwiftCron' => ['SwiftCron/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

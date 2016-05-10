Pod::Spec.new do |s|

  s.name         = "SwiftCron"
  s.version      = "0.0.4"
  s.summary      = "Cron expression parser"

  s.description  = <<-DESC
                   A cron expression parser written in Swift that can take a cron string and give you the next run date and time specified in the string.
		   DESC

  s.homepage     = "https://github.com/Rush42/SwiftCron"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Keegan Rush" => "galaxyplansoftware@gmail.com" }
  s.social_media_url   = "https://twitter.com/RushKeegan"

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Rush42/SwiftCron.git", :tag => "0.0.4" }
  s.source_files  = "SwiftCron", "SwiftCron/**/*.swift}"
#s.exclude_files = "Classes/Exclude"

end

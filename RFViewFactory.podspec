Pod::Spec.new do |s|
  s.name         = "RFViewFactory"
  s.version      = "0.1.1"
  s.summary      = "RFViewFactory is a view controller factory pattern for creating iPhone applications, inspired from Android activity lifecycle."
  s.description  = <<-DESC
          RFViewFactory provides a view factory, scripts to create VCs, and a MVC pattern for showing iPhone views.
                    DESC
  s.homepage     = "https://github.com/RFViewFactory/RFViewFactory.git"
  s.license      = 'MIT'
  s.author       = { "Richard H Fung" => "contact@rhfung.com" }
  s.source       = { :git => "https://github.com/RFViewFactory/RFViewFactory.git", :tag => "0.1.1" }
  s.platform     = :ios
  s.ios.deployment_target = '5.1'
  s.source_files = 'RFViewFactory/**/*.{h,m}'
  s.resources    = 'RFViewFactory/**/*.xib'
  s.frameworks = 'QuartzCore', 'AVFoundation', 'UIKit', 'Foundation'
  s.requires_arc = true
end

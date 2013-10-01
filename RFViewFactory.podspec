Pod::Spec.new do |s|
  s.name         = "RFViewFactory"
  s.version      = "0.1.0"
  s.summary      = "RFViewFactory is a view controller factory pattern for creating iPhone applications, inspired from Android activity lifecycle."
  s.description  = <<-DESC
          RFViewFactory is a view controller factory pattern for creating iOS applications.
          Designed with a two-level hierachical view controller structure. 
          Inspired by Android activity lifecycle.
                    DESC
  s.homepage     = "https://github.com/RFViewFactory/RFViewFactory.git"
  s.license      = 'MIT'
  s.author       = { "Richard H Fung" => "contact@rhfung.com" }
  s.source       = { :git => "https://github.com/RFViewFactory/RFViewFactory.git", :tag => "0.1.0" }
  s.platform     = :ios
  s.source_files = 'RFViewFactory/**/*.{h,m,xib}'
  s.resources    = 'RFViewFactory/**/*.xib'
  s.frameworks = 'QuartzCore', 'AVFoundation', 'UIKit', 'Foundation'
  s.requires_arc = true
end

#
#  Be sure to run `pod spec lint Kron.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#


Pod::Spec.new do |s|

  
  s.name         = "Lux"
  s.version      = '0.17.1'
  s.summary      = "DSL for UI Look Development + SwiftUI"

  
  s.description  = <<-DESC
  DSL for UI Look Development + SwiftUIDESC
  DESC

  s.homepage     = "https://maxwell.design"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = { :type => "GNU GPLv3", :file => "LICENSE" }

  s.authors            = { "eonflux" => "eonfluxor@gmail.com" }


   s.ios.deployment_target = '13.1'
   #s.osx.deployment_target = '10.15'
   #s.tvos.deployment_target = '9.0'
   #s.watchos.deployment_target = '2.0'


  s.source       = { :git => "git@github.com:maxwelldesign/lux.git", :tag => "v#{s.version}" }
  s.weak_frameworks = 'SwiftUI', 'Combine', 'UIKit'

  s.source_files = 'Lux/**/*.swift'
  s.pod_target_xcconfig = {
    'SUPPORTS_MACCATALYST' => 'YES',
    'DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER' => 'NO',
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'
  }


  s.swift_version = '5.2'



end

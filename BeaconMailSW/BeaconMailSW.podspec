#
#  Be sure to run `pod spec lint BeaconMailSW.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "BeaconMailSW"
  s.version      = "0.0.1"
  s.summary      = "BeaconMailSW."
  s.description  = "BeaconMailSW"

  s.homepage     = "http://google.com"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.license      = "MIT"


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author             = { "longdq" => "longdq.adnetplus@gmail.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # s.platform     = :ios, "8.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source       = { :path => '.'}


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files  = "BeaconMailSW", "BeaconMailSW/**/*.{h,m,swift}"
  s.exclude_files = "BeaconMailSW/Exclude"



  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.resources = "BeaconMailSW/**/*.{png,jpeg,jpg,storyboard,xib,xcdatamodeld,xcassets,json,txt,strings}"
  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.framework  = 'CoreData'


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency 'Toast', '~> 2.4'
  s.dependency 'SDWebImage', '~> 3.7.1'
  s.dependency 'AFNetworking', '~> 3.0.0'
  s.dependency 'Postal'
  s.dependency 'TPKeyboardAvoiding', '~> 1.2.8'
  s.dependency 'SwiftyXMLParser'
  s.dependency 'UIActivityIndicator-for-SDWebImage'
  s.dependency 'Alamofire', '~> 4.0'
  

end

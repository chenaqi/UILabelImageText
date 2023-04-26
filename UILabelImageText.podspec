#
# Be sure to run `pod lib lint UILabelImageText.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UILabelImageText'
  s.version          = '0.1.0'
  s.summary          = 'Use UILabel to achieve image and text mixed layout, supporting click events.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Suitable for the first icon following the text, the icon can be clicked, 
and some text can be specified to support clicking
                       DESC

  s.homepage         = 'https://github.com/chenaqi/UILabelImageText'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chenwuqi' => '925769607@qq.com' }
  s.source           = { :git => 'https://github.com/chenaqi/UILabelImageText.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.0'

  s.source_files = 'UILabelImageText/Classes/**/*'
  
  # s.resource_bundles = {
  #   'UILabelImageText' => ['UILabelImageText/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end

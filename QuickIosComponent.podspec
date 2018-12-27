#
# Be sure to run `pod lib lint QuickIosComponent.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QuickIosComponent'
  s.version          = '0.1.1'
  s.summary          = 'iOS Library for Quick development.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
This Library is just Quick iOS development for me.
This contains these. MVS (model-view-state) architecture components, UIKit extensions, Useful components and so on.
                        DESC

  s.homepage         = 'https://github.com/brownsoo/QuickIosComponent'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brownsoo' => 'hansune@me.com' }
  s.source           = { :git => 'https://github.com/brownsoo/QuickIosComponent.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hansoolabs'

  s.ios.deployment_target = '11.0'
  #s.osx.deployment_target     = '10.10'
  #s.tvos.deployment_target    = '9.0'
  #s.watchos.deployment_target = '2.0'

  s.source_files = 'QuickIosComponent/Classes/**/*'
  
  # s.resource_bundles = {
  #   'QuickIosComponent' => ['QuickIosComponent/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'ReSwift'
  s.dependency 'ReSwiftConsumer'
  s.dependency 'RxSwift', '~> 4.0'
  s.dependency 'RxCocoa', '~> 4.0'
end

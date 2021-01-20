#
# Be sure to run `pod lib lint CalendarView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CalendarView"
  s.version          = "1.1.2"
  s.summary          = "A lightweight calendar view."
  s.description      = <<-DESC
                       A calendar view with a focus on:

                       * Speed
                       * Simplicity
                       * Customization
                       DESC
  s.homepage         = "https://github.com/n8armstrong/CalendarView"
  s.screenshots     = "https://raw.githubusercontent.com/n8armstrong/CalendarView/master/screens/screenshot.png"
  s.license          = 'MIT'
  s.author           = { "Nate Armstrong" => "natearmstrong2@gmail.com" }
  s.source           = { :git => "https://github.com/n8armstrong/CalendarView.git", :branch => master }
  s.social_media_url = 'https://twitter.com/N8armstrong'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'CalendarView/CalendarView/Classes/**/*'
  s.resource_bundles = {
    'CalendarView' => ['Pod/Assets/*.png']
  }

  s.frameworks = 'UIKit'
end

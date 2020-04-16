#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint zendesk.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'zendesk'
  s.version          = '0.0.1'
  s.summary          = 'Zendesk plugin.'
  s.description      = <<-DESC
Zendesk plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Wahyoo' => 'email@wahyoo.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'ZendeskChatSDK'
  s.dependency 'ZendeskSupportSDK'
  s.dependency 'ZendeskAnswerBotSDK'
  s.static_framework = true
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end

# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'Timer-Todo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Timer-Todo
  pod 'KDCircularProgress'
  pod 'FSCalendar'
  pod 'RealmSwift', git: 'https://github.com/realm/realm-cocoa.git', branch: 'master', submodules: true
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/wowansm/Chameleon', :branch => 'swift5'
  pod 'Onboard'
  pod 'Google-Mobile-Ads-SDK'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.6'
    end
  end
end


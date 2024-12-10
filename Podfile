platform :ios, '12.0'

target 'Diary' do
  use_frameworks!

  pod 'SnapKit'
  pod 'RealmSwift'
  pod 'IQKeyboardManagerSwift', '6.5.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if ['Realm', 'RealmSwift'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
end


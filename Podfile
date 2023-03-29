# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def all_pods
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
end

target 'TapPlace' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'RealmSwift', '~>10'
  pod 'SnapKit', '~> 5.6.0'
  pod 'NMapsMap'
  pod 'Alamofire'
  pod 'AlignedCollectionViewFlowLayout'
  pod 'FloatingPanel'
  pod 'IQKeyboardManagerSwift'
  pod 'SwiftKeychainWrapper'
  pod 'SwiftJWT'
  pod 'EFCountingLabel'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'

  # Pods for TapPlace

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
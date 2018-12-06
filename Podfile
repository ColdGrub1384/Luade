# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Luade' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Luade

  pod 'SourceEditor', :git => 'https://github.com/ronaldmannak/source-editor.git'
  pod 'FloatingPanel'
  pod 'InputAssistant'
end

target 'Run Lua Script' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    # Pods for Run Lua Script

    pod 'SourceEditor', :git => 'https://github.com/ronaldmannak/source-editor.git'
    pod 'FloatingPanel'
    pod 'InputAssistant'
end

# post install
post_install do |installer|
    # Build settings
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings = config.build_settings.dup
            if config.build_settings['PRODUCT_MODULE_NAME'] == 'SavannaKit' || config.build_settings['PRODUCT_MODULE_NAME'] == 'SourceEditor'
                puts "Set Swift version"
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end

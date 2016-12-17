#source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "10.0"

use_frameworks!

def testing_pods
pod 'Quick'
pod 'Nimble'
end

target 'Tiny Against the Giants' do
pod 'Google-Mobile-Ads-SDK'

target 'Tiny Against the GiantsTests' do
inherit! :search_paths
testing_pods
end
end

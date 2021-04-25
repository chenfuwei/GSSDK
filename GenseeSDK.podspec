#
#  Be sure to run `pod spec lint PodTest.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "GenseeSDK"
  spec.version      = "1.1.2"
  spec.summary      = "Gensee SDK."


  spec.description  = <<-DESC
                   All iOS framework for Gensee.
                   DESC

  spec.homepage     = "http://www.gensee.com"


spec.static_framework = true
  spec.license      = {:type => "MIT",:text=> <<-LICENSE
    Copyright PPAbner 2016-2021
    LICENSE
  }


  spec.author             = { "net263" => "mobile-gensee@net263.com" }

  spec.platform     = :ios, "9.0"

  spec.ios.deployment_target = "9.0"
  spec.default_subspecs = "GSPlayerSDK"

  spec.source       = { :git => "https://github.com/chenfuwei/GSSDK.git", :tag => "#{spec.version}" }
  spec.static_framework = true
  spec.pod_target_xcconfig = {
      "ENABLE_BITCODE" => "NO",
      'VALID_ARCHS' => 'x86_64 armv7 arm64',
      'OTHER_LDFLAGS' => '-lObjC' 
    }


  #PlayerSDk,轻量级版本，主要用户以观看场景为主，音视频互动弱的场景
  spec.subspec 'GSPlayerSDK' do |ss|
    ss.vendored_frameworks  = [
    'frameworks/PlayerSDK.framework'
    ]
    ss.resources            = [
      "bundles/PlayerSDK.bundle"
    ]
    ss.vendored_libraries = [
    'Libs/libPlayerSDKLib.a'
  ]
    ss.dependency "GenseeSDK/GSDocSDK"
  end

  #RtSDK，交互场景丰富，观看及发布直播都支持的实时SDK
  spec.subspec 'GSRtSDK' do |ss|
    ss.vendored_frameworks  = [
    'frameworks/RtSDK.framework'
    ]
    ss.resources            = [
      "bundles/RtSDK.bundle"
    ]
    ss.dependency "GenseeSDK/GSDocSDK"
  end

  #RtSDK，交互场景丰富，观看及发布直播都支持的实时SDK
  spec.subspec 'GSFastSDK' do |ss|
    ss.vendored_frameworks  = [
    'frameworks/FASTSDK.framework'
    ]
    ss.resources            = [
      "bundles/FastSDK.bundle"
    ]
    ss.dependency "GenseeSDK/GSRtSDK"
    ss.dependency "GenseeSDK/GSPlayerSDK"
    ss.dependency 'MBProgressHUD', '~> 1.1.0'
  ss.dependency 'Masonry', '~> 1.1.0'
  ss.dependency 'MZTimerLabel', '~> 0.5.4'
  ss.dependency 'IQKeyboardManager', '~> 6.1.1'
  ss.dependency 'ThemeManager', '~> 1.0.1'
  ss.dependency 'MJRefresh', '~> 3.1.15.7'
  end


  #红包SDK,配套PlayerSDk使用
  spec.subspec 'GSHongbaoSDK' do |ss|
    ss.vendored_frameworks  = [
    'frameworks/GSHongbaoKit.framework'
    ]
    ss.dependency "GenseeSDK/GSCommonSDK"
  end

  #打赏SDK,使用支付宝打赏
  spec.subspec 'GSRewardSDK' do |ss|
    ss.vendored_frameworks  = [
    'frameworks/GSRewardKit.framework'
    ]
    ss.dependency "GenseeSDK/GSCommonSDK"
  end

  spec.libraries =  'c++'
  spec.frameworks = 'GLKit'
  spec.vendored_libraries = [
    'Libs/liblibfaad.a',
    'Libs/libx264.a',
    'Libs/ffmpeg/*.a'
  ]


#***************internal****************************#
  spec.subspec 'GSDocSDK' do |ss|
    ss.vendored_frameworks  = [
    'frameworks/GSDocKit.framework'
    ]
    ss.dependency "GenseeSDK/GSCommonSDK"
    ss.dependency "GenseeSDK/GSHeartBeatSDK"
    ss.dependency "GenseeSDK/GSGPUImageSDK"
  end
  spec.subspec 'GSGPUImageSDK' do |ss|
    ss.vendored_frameworks  = [
    'frameworks/GPUImage.framework'
    ]
  end
  spec.subspec 'GSCommonSDK' do |ss|
    ss.vendored_frameworks  = [
    'frameworks/GSCommonKit.framework'
    ]
    ss.dependency "GenseeSDK/GSGPUImageSDK"
  end
  spec.subspec 'GSHeartBeatSDK' do |ss|
    ss.vendored_frameworks  = [
    'frameworks/GSHeartbeatKit.framework'
    ]
  end

end

Pod::Spec.new do |s|
  s.name         = "KBPopupBubble"
  s.version      = "0.0.2"
  s.summary      = "Twitter-style popup bubbles with dynamic, animated pointer arrows."
  s.homepage     = "https://github.com/mmmilo/KBPopupBubble"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { "Michael Lo" => "michael.lo@pocoapps.com", "psholtz" => '' }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/mmmilo/KBPopupBubble.git", :tag => s.version.to_s }
  s.source_files  = 'KBPopupBubble/KBPopupBubble/*.{h,m}'
  s.frameworks   = 'Foundation', 'UIKit', 'QuartzCore'
  s.requires_arc = true
end

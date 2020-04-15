Pod::Spec.new do |s|
  s.name             = 'GHFontList'
  s.version          = '0.0.1'
  s.summary          = 'Show all the font names and font styles supported in the app.'

  s.description      = <<-DESC
Show all the font names and font styles supported in the app.
                       DESC

  s.homepage         = 'https://github.com/ghosthk/GHFontList'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ghosthk' => 'ghosthkfly@gmail.com' }
  s.source           = { :git => 'https://github.com/ghosthk/GHFontList', :tag => s.version.to_s}
  s.platform         = :ios, '10.0'
  s.ios.deployment_target = '10.0'
  s.requires_arc = true

  s.source_files = 'FontList/*.{h,m}'
end

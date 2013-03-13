Pod::Spec.new do |s|
  s.name         = 'MSTableKit'
  s.version      = '0.0.1'
  s.license      = 'MIT'
  s.platform     = :ios, '5.0'

  s.summary      = 'MSTableKit enables significantly deeper customization of the visual appearance of iOS tables'
  s.homepage     = 'https://github.com/monospacecollective/MSTableKit'
  s.author       = { 'Eric Horacek' => 'eric@monospacecollective.com' }
  s.source       = { :git => 'https://github.com/monospacecollective/MSTableKit.git', :tag => s.version.to_s }

  s.source_files = 'MSTableKit/*.{h,m}'
  
  s.requires_arc = true
  s.frameworks   = 'QuartzCore'

  s.dependency 'UIColor-Utilities'    , '~> 1.0.1'
  s.dependency 'KGNoise'              , '~> 1.1.0'
end

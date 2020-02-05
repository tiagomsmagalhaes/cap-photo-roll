
  Pod::Spec.new do |s|
    s.name = 'CapPhotoRoll'
    s.version = '0.0.1'
    s.summary = 'Photo Roll API'
    s.license = 'MIT'
    s.homepage = 'https://github.com/tiagomsmagalhaes/cap-photo-roll'
    s.author = 'Tiago Magalhães'
    s.source = { :git => 'https://github.com/tiagomsmagalhaes/cap-photo-roll', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
  end
Pod::Spec.new do |s|
  s.name         = "GRKConcurrentCollections"
  s.version      = "1.0"
  s.summary      = "Threadsafe collections for Objective C."
  s.description  = <<-DESC
Classes which encapsulate NSMutableArray, NSMutableDictionary, and NSMutableSet for
threadsafe concurrent read and write access.
    DESC
  s.homepage     = "https://github.com/levigroker/GRKConcurrentCollections"
  s.license      = 'Creative Commons Attribution 3.0 Unported License'
  s.author       = { "Levi Brown" => "levigroker@gmail.com" }
  s.social_media_url = 'https://twitter.com/levigroker'
  s.source       = { :git => "https://github.com/levigroker/GRKConcurrentCollections.git", :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.source_files = 'GRKConcurrentCollections/**/*.{h,m}'
end

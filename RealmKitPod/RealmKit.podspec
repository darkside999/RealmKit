Pod::Spec.new do |s|

  s.name = "RealmKit"
  s.version = "0.1"
  s.summary = "RealmKit для приложений"

  s.platform = :ios, "11.0"
  s.swift_version = '5'

  s.description  = <<-DESC
  RealmKit для приложений.
                   DESC

  s.homepage     = "https://git. .com/ios/src"

  s.license = { :type => 'MIT', :text => <<-LICENSE
                   Copyright 2019
                   Permission is granted to
                 LICENSE
               }

  s.author = { "Indir Amerkhanov" => "voltmor@gmail.com" }

  s.source = { :git => "https://git. .com/ios/src", :tag => "#{s.version}" }

  s.source_files = [
    'Sources/**/*.{h,m,swift}'
  ]

  s.exclude_files = [
    'Sources/**/*Tests.swift',
  ]

  s.resources = [
    "Resources/**/*"
  ]
  
  s.dependency 'RealmSwift'
end


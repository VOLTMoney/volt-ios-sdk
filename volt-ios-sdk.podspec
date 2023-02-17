

Pod::Spec.new do |spec|
  spec.name         = "VoltFramework"
  spec.version      = "1.0.0"
  spec.summary      = "VoltFramework ia a framework."
  spec.swift_versions    = "5.0"

  spec.homepage     = "https://github.com/VOLTMoney/volt-ios-framework.git"
  spec.description   = "VoltFramework.git is a swift framework"

  spec.license      = "VoltMoney"
  spec.author       = { "Soumya Sethy" => "soumya.sethy@voltmoney.in" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git => "https://github.com/VOLTMoney/volt-ios-framework.git", :tag => "1.0.0" }
  spec.ios.vendored_frameworks = "VoltFramework.framework"
end



Pod::Spec.new do |spec|
  spec.name         = "volt-ios-sdk"
  spec.version      = "1.0.0"
  spec.summary      = "volt-ios-sdk ia a framework."
  spec.swift_versions    = "5.0"

  spec.description  = <<-DESC
                   DESC

  spec.homepage     = "https://github.com/VOLTMoney/volt-ios-sdk.git"
  spec.description   = "volt-ios-sdk.git is a swift framework"

  spec.license      = "VoltMoney"
  spec.author       = { "Soumya Sethy" => "soumya.sethy@voltmoney.in" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git => "https://github.com/VOLTMoney/volt-ios-sdk.git", :tag => "1.0.0" }

  spec.source_files  = "VoltFramework/VoltSDKContainer.swift", "VoltFramework/VoltInstance.swift", "VoltFramework/VoltHomeViewController.swift",
  "VoltFramework/BaseViewController.swift",
  "VoltFramework/Managers/*.swift",
          "VoltFramework/Model/*.swift",
               "VoltFramework/Managers/ReachabilityManager/*.swift"


end

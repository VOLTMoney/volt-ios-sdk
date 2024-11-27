//
//  CreateApplication.swift
//  VoltDemo
//
//  Created by R.P.Kumar.Mishra on 10/02/23.
//

import Foundation

public struct APIResponse: Codable {
    public var customerAccountId: String?
    var customerCreditApplicationId: String?
    var statusCode: String?
    public var message: String?
    var authToken: String?

    enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
        case customerAccountId, customerCreditApplicationId, statusCode, message
    }
}

// MARK: - ClientDetails
struct ClientDetails: Codable {
    let type, accountID, accountState: String?
    let isInternal: Bool?
    let accountTier: String?
    let addedOnTimeStamp, lastUpdatedTimeStamp: Int?
    let platformName: String?
    let platformLogoImgSrc: String?
    let callbackURL: String?
    let platformCode: String?
    let platformAgreementIDURI, address: String?
    let platformCredentialsDetails: PlatformCredentialsDetails?
    let platformSDKConfig: PlatformSDKConfig?

    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case accountID = "accountId"
        case accountState, isInternal, accountTier, addedOnTimeStamp, lastUpdatedTimeStamp, platformName, platformLogoImgSrc, callbackURL, platformCode
        case platformAgreementIDURI = "platformAgreementIdUri"
        case address, platformCredentialsDetails, platformSDKConfig
    }
}

// MARK: - PlatformCredentialsDetails
struct PlatformCredentialsDetails: Codable {
    let appKey, appSecret: String?
    let passwordHash: String?

    enum CodingKeys: String, CodingKey {
        case appKey = "app_key"
        case appSecret = "app_secret"
        case passwordHash
    }
}

// MARK: - PlatformSDKConfig
struct PlatformSDKConfig: Codable {
    let showVoltDefaultHeader, showVoltLogo, showHome, showLogout: Bool?
    let showPostLoanJourney: Bool?
    let customLogoURL: String?
    let customSupportNumber: String?
    let showPoweredByVoltMoney: Bool?
    let showVoltBottomNavBar : Bool?
    let csPillData : CSPillData?
    enum CodingKeys: String, CodingKey {
        case showVoltDefaultHeader, showVoltLogo, showHome, showLogout, showPostLoanJourney
        case customLogoURL = "customLogoUrl"
        case customSupportNumber, showPoweredByVoltMoney
        case showVoltBottomNavBar,csPillData
    }
}

struct CSPillData: Codable {
    let waData: String?        // WhatsApp data
    let showWA: Bool?          // Show WhatsApp
    let showEmail: Bool?       // Show Email
    let showCall: Bool?        // Show Call
    let emailData: String?     // Email data
    let customIconUrl: String? // Custom icon URL
    let callData: String?      // Call data
}

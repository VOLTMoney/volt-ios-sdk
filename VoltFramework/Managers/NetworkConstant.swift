//
//  NetworkConstant.swift
//  VoltFramework
//
//  Created by 
//

import Foundation

public enum VOLTENV: CustomStringConvertible {
    case STAGING
    case PRODUCTION

    public var description: String {
        switch self {
        case .STAGING:
            return "https://app.staging.voltmoney.in/partnerplatform?"
        case .PRODUCTION:
            return "https://app.voltmoney.in/partnerplatform?"
        }
    }
}

class NetworkConstant {

    static let platform: String = "SDK_INVESTWELL"
    static let baseURL: String = "https://api.staging.voltmoney.in"
    static let webBaseURL: String = "https://app.staging.voltmoney.in/partnerplatform?"

    static let loginTokenURL: String = baseURL + "/v1/partner/platform/auth/login"
    static let createCreditApplicationURL = baseURL + "/v1/partner/platform/las/createCreditApplication"
    static let getPlatoformDetails = baseURL + "/v1/partner/platform/las/createCreditApplication"


    static let loadWebViewURL = baseURL

    static let appKey = "volt-sdk-staging@voltmoney.in"
    static let appSecret = "e10b6eaf2e334d1b955434e25fcfe2d8"

}

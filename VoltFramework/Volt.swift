//
//  Volt.swift
//  VoltFramework
//
//  Created
//

import Foundation

protocol VoltProtocol {
    static func precreateApplication(dob: String, email: String, panNumber: String, mobileNumber: Int, callback: ((_ response: APIResponse?) -> Void)?)
    static func initVoltSDK(mobileNumber: String) -> URL?
    static var voltInstance: VoltInstance? { get }
}

public class Volt: VoltProtocol {
    static var voltInstance: VoltInstance?

    public init(voltInstance: VoltInstance? = nil) {
        Volt.voltInstance = voltInstance
    }

    public static func initVoltSDK(mobileNumber: String) -> URL? {
        var webURL = NetworkConstant.webBaseURL
        if self.voltInstance?.ref != nil {
            let ref = "ref=" + (voltInstance?.ref ?? "") + "&"
            webURL.append(ref)
        }

        if voltInstance?.primary_color != nil {
            let primaryColor = "primaryColor=" + (voltInstance?.primary_color ?? "") + "&"
            webURL.append(primaryColor)
        }

        if voltInstance?.secondary_color != nil {
            let secondaryColor = "secondaryColor=" + (voltInstance?.secondary_color ?? "") + "&"
            webURL.append(secondaryColor)
        }

        if mobileNumber != "" {
            let mobileNumber = "user=" + mobileNumber + "&"
            webURL.append(mobileNumber)
        }

        if voltInstance?.partner_platform != nil {
            let partnerPlatform = "platform=" + (voltInstance?.partner_platform ?? "")
            webURL.append(partnerPlatform)
        }

        return URL(string: webURL)
    }

    private static func generateClientToken() -> (APIResponse?, Bool?) {
        var responseData: APIResponse?
        if let authTokenData = RestApiManager.getLoginToken(urlString: NetworkConstant.loginTokenURL, appKey: voltInstance?.app_key ?? "", appSecret: voltInstance?.app_secret ?? "", method: .post) {
            do {
                responseData = try JSONDecoder().decode(APIResponse.self, from: authTokenData)
                if responseData?.authToken != nil {
                    UserDefaults.standard.set(responseData?.authToken, forKey: "authToken")
                    return (responseData, true)
                } else {
                    return (responseData, false)
                }
            } catch (let error) {
                print(error)
                return (responseData, false)
            }
        } else {
            return (responseData, false)
        }
    }

    public static func precreateApplication(dob: String, email: String, panNumber: String, mobileNumber: Int, callback: ((_ response: APIResponse?) -> Void)?) {
        var responseData: APIResponse?
        if generateClientToken().1 == true {
            if let createApplicationData = RestApiManager.createCreditApplication(urlString: NetworkConstant.createCreditApplicationURL, dob: dob, email: email, panNumber: panNumber, mobileNumber: mobileNumber, method: .post) {
                do {
                    responseData = try JSONDecoder().decode(APIResponse.self, from: createApplicationData)
                    if responseData?.customerAccountId != nil {
                        callback?(responseData)
                    } else {
                        callback?(responseData)
                    }
                } catch(let error) {
                    print(error)
                    callback?(responseData)
                }
            } else {
                callback?(responseData)
            }
        } else {
            callback?(generateClientToken().0)
        }
    }
}

//
//  Volt.swift
//  VoltFramework
//
//  Created
//

import Foundation

protocol VoltProtocol {
    static func createApplication(dob: String, email: String, panNumber: String, mobileNumber: Int, callback: ((_ response: APIResponse?) -> Void)?)
    static func createVoltSDKUrl() -> URL?
    static var voltInstance: VoltInstance? { get }
}

public class Volt: VoltProtocol {
    static var voltInstance: VoltInstance?
    static var mobileNumber: Int? = 0

    public init(voltInstance: VoltInstance? = nil) {
        Volt.voltInstance = voltInstance
    }

    public static func createVoltSDKUrl() -> URL? {
        var webURL = NetworkConstant.webBaseURL + "/?"
        if self.voltInstance?.ref != nil {
            let ref = "ref=" + (voltInstance?.ref ?? "") + "&"
            webURL.append(ref)
        }

        if voltInstance?.primaryColor != nil {
            let primaryColor = "primaryColor=" + (voltInstance?.primaryColor ?? "") + "&"
            webURL.append(primaryColor)
        }

        if voltInstance?.secondaryColor != nil {
            let secondaryColor = "secondaryColor=" + (voltInstance?.secondaryColor ?? "") + "&"
            webURL.append(secondaryColor)
        }

        if self.mobileNumber != nil {
            let mobileNumber = "user=" + String(self.mobileNumber ?? 0) + "&"
            webURL.append(mobileNumber)
        }

        if voltInstance?.partnerPlatform != nil {
            let partnerPlatform = "partnerplatform?platform=" + (voltInstance?.partnerPlatform ?? "")
            webURL.append(partnerPlatform)
        }

        return URL(string: webURL)
    }

    private static func generateClientToken() -> (APIResponse?, Bool?) {
        var responseData: APIResponse?
        if let authTokenData = RestApiManager.getLoginToken(urlString: NetworkConstant.loginTokenURL, appKey: voltInstance?.appKey ?? "", appSecret: voltInstance?.appSecret ?? "", method: .post) {
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

    public static func createApplication(dob: String, email: String, panNumber: String, mobileNumber: Int, callback: ((_ response: APIResponse?) -> Void)?) {
        self.mobileNumber = mobileNumber
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

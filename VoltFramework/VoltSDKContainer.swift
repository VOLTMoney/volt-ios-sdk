//
//  Volt.swift
//  VoltFramework
//
//  Created
//


import Foundation

protocol VoltProtocol {
    static func preCreateApplication(dob: String, email: String, panNumber: String, mobileNumber: Int, callback: ((_ response: APIResponse?) -> Void)?)
    static var voltInstance: VoltInstance? { get }
}

public class VoltSDKContainer: VoltProtocol {
    internal static var voltInstance: VoltInstance?

    public init(voltInstance: VoltInstance? = nil) {
        VoltSDKContainer.voltInstance = voltInstance
    }

    
    internal static func initVoltSDK(authToken: String, platformCode : String) async -> URL? {
        let ref = voltInstance?.ref ?? ""
        let primaryColor = voltInstance?.primary_color ?? ""
        let target = voltInstance?.target ?? ""
        let secondaryColor = voltInstance?.secondary_color ?? ""
        let ssoToken = voltInstance?.ssoToken ?? ""

        let bodyDataTemp = [
            "sdkType": "IOS_SDK",
            "ref": ref,
            "pColor": primaryColor,
            "target": target,
            "sColor": secondaryColor,
            "customerSsoToken": ssoToken
        ]

        
        do {
            if let sdkURL = try await RestApiManager().fetchSDKUrl(
                isStaging: voltInstance?.voltEnv == VOLTENV.STAGING,
                bodyData: bodyDataTemp,
                appPlatform: platformCode,
                authToken: authToken,
                method: .post
            ) {
                print("Fetched SDK URL")
                return sdkURL;
            } else {
                print("SDK URL not found")
                return nil
            }
        } catch {
            print("Error fetching SDK URL: \(error)")
            return nil
        }        
    }


    

    public static func FaqClicked(){

    }
    
    
    public static  func logout(){
        URLCache.shared.removeAllCachedResponses()
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    

    public static func preCreateApplication(dob: String, email: String, panNumber: String, mobileNumber: Int, callback: ((_ response: APIResponse?) -> Void)?) {
        var _: APIResponse?

    }
}

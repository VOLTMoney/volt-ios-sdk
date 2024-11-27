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
        do {
            let fetchDataResult = try await RestApiManager.init().fetchData(authToken: authToken, platformCode: platformCode, isStaging: voltInstance?.voltEnv == VOLTENV.STAGING )
            print("Is the token valid? \(fetchDataResult.0)")
            // You can perform additional actions here if needed.
            if fetchDataResult.0 {
                let fetchDataResponse = fetchDataResult.1
                var webURL = voltInstance?.voltEnv?.description
                if self.voltInstance?.ref != "" {
                    let ref = "ref=" + (voltInstance?.ref ?? "") + "&"
                    webURL?.append(ref)
                }
                
                
                let showVoltDefaultHeader = "showVoltDefaultHeader=" + (fetchDataResponse?.platformSDKConfig?.showVoltDefaultHeader?.description ?? "") + "&"
                webURL?.append(showVoltDefaultHeader)
                
                webURL?.append("isFromiOSSdk=true&")

                let showVoltLogo = "showVoltLogo=" + (fetchDataResponse?.platformSDKConfig?.showVoltLogo?.description ?? "") + "&"
                webURL?.append(showVoltLogo)
                
                let customLogoUrl = "customLogoUrl=" + (fetchDataResponse?.platformSDKConfig?.customLogoURL?.description ?? "") + "&"
                webURL?.append(customLogoUrl)
                
                
                let showWA = "showWA=" + (fetchDataResponse?.platformSDKConfig?.csPillData?.showWA?.description ?? "") + "&"
                webURL?.append(showWA)

                
                
                let callData = "callData=" + (fetchDataResponse?.platformSDKConfig?.csPillData?.callData?.description ?? "") + "&"
                webURL?.append(callData)
                
                let emailData = "emailData=" + (fetchDataResponse?.platformSDKConfig?.csPillData?.emailData?.description ?? "") + "&"
                webURL?.append(emailData)
                
                
                let showHome = "showHome=" + (fetchDataResponse?.platformSDKConfig?.showHome?.description ?? "") + "&"
                webURL?.append(showHome)
                
                let showBottomNav = "showVoltBottomNavBar=" + (fetchDataResponse?.platformSDKConfig?.showVoltBottomNavBar?.description ?? "") + "&"
                webURL?.append(showBottomNav)
            
                
                let showLogout = "showLogout=" + (fetchDataResponse?.platformSDKConfig?.showLogout?.description ?? "") + "&"
                webURL?.append(showLogout)

                webURL?.append(showLogout)
                if (voltInstance?.primary_color != "") {
                    let primaryColor = "primaryColor=" + (voltInstance?.primary_color ?? "") + "&"
                    webURL?.append(primaryColor)
                }
                if (voltInstance?.target != "") {
                    let target = "target=" + (voltInstance?.target ?? "") + "&"
                    webURL?.append(target)
                }
                
            
                if (voltInstance?.secondary_color != "") {
                    let secondaryColor = "secondaryColor=" + (voltInstance?.secondary_color ?? "") + "&"
                    webURL?.append(secondaryColor)
                }
                
                if (voltInstance?.partner_platform != "") {
                    let partnerPlatform = "platform=" + (voltInstance?.partner_platform ?? "") + "&"
                    webURL?.append(partnerPlatform)
                }
                
                if(voltInstance?.ssoToken != ""){
                    let ssoToken = "ssoToken=" +  (voltInstance?.ssoToken ?? "") + "&"
                    webURL?.append(ssoToken)
                }
                
                
                return URL(string: webURL ?? "")
            } else {
                return nil
            }
        } catch {
            print("Error fetching data: \(error)")
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
        var responseData: APIResponse?

    }
}

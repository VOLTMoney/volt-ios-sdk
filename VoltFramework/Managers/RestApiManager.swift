//
//  RestApiManager.swift
//  VoltFramework
//
//  Created by Sagar bhatnagar
//

import Foundation

enum FetchDataError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case statusCodeError(Int)
    case noData
    case jsonDecodingError(Error)
}

class RestApiManager {

    static func getLoginToken(urlString: String, appKey: String, appSecret: String, method: HttpMethod) -> Data? {

        if let url =  URL.init(string: urlString) {
            var resource = Resource<Data?>(url: url)
            resource.httpMethod = method
            let bodyData = ["app_key" : appKey, "app_secret" : appSecret]
            let jsonData = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
            resource.body = jsonData
            let headers = ["Content-Type": "application/json"]

            resource.header = headers

            let result = NetworkManager().serviceCall(resource: resource)
            switch result {
            case .success(let data):
                if data != nil {
                    return data
                }
            case .failure(.invalidResponse(let data)):
                if data != nil {
                    return data
                }
            }
            return nil
        }
        return nil
    }
    
    static func getPlatformDetails(urlString: String, appKey: String, appSecret: String, method: HttpMethod) -> Data? {

        if let url =  URL.init(string: urlString) {
            var resource = Resource<Data?>(url: url)
            resource.httpMethod = method
            let bodyData = ["app_key" : appKey, "app_secret" : appSecret]
            let jsonData = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
            resource.body = jsonData
            let headers = ["Content-Type": "application/json"]

            resource.header = headers

            let result = NetworkManager().serviceCall(resource: resource)
            switch result {
            case .success(let data):
                if data != nil {
                    return data
                }
            case .failure(.invalidResponse(let data)):
                if data != nil {
                    return data
                }
            }
            return nil
        }
        return nil
    }

   


    static func createCreditApplication(urlString: String, dob: String, email: String, panNumber: String, mobileNumber: Int, method: HttpMethod) -> Data? {

        if let url =  URL.init(string: urlString) {
            var resource = Resource<Data?>(url: url)
            resource.httpMethod = method
            var bodyData = [String : Any]()
            bodyData["dob"] = dob
            bodyData["email"] = email
            bodyData["pan"] = panNumber
            bodyData["mobileNumber"] = mobileNumber

            let jsonData = try? JSONSerialization.data(withJSONObject: ["customerDetails" : bodyData], options: [])
            resource.body = jsonData
            let authToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
            let headers = ["Content-Type": "application/json",
                       "Authorization": "Bearer \(authToken)",
                           "X-AppPlatform": NetworkConstant.platform]

            resource.header = headers

            let result = NetworkManager().serviceCall(resource: resource)
            switch result {
            case .success(let data):
                if data != nil {
                    return data
                }
            case .failure(.invalidResponse(let data)):
                if data != nil {
                    return data
                }
            }
            return nil
        }
        return nil
    }
    
    
    func generateRandomReferenceId() -> String {
        let randomValue = Int.random(in: 0...Int.max)
        return String(String(randomValue, radix: 36).suffix(8)) // Adjust length as needed
    }
    
    
    func fetchSDKUrl(
        isStaging: Bool,
        bodyData: [String: String],
        appPlatform: String,
        authToken: String,
        method: HttpMethod
    ) async throws -> URL? {
        
        
        
        let urlString  : String
        if isStaging {
            urlString = "https://api.staging.voltmoney.in/v1/partner/platform/generate/sdk/url"
        } else {
            urlString = "https://api.voltmoney.in/v1/partner/platform/generate/sdk/url"
        }
        
        guard let url = URL(string: urlString) else {
            throw FetchDataError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Set headers
        let headers = [
            "Content-Type": "application/json",
            "X-AppPlatform": appPlatform,
            "Authorization": "Bearer \(authToken)",
            "requestReferenceId" : generateRandomReferenceId()
        ]
        request.allHTTPHeaderFields = headers
        
        // Add body data if POST/PUT
        if method == .post || method == .put {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: bodyData, options: [])
                request.httpBody = jsonData
            } catch {
                throw FetchDataError.invalidResponse
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw FetchDataError.invalidResponse
            }
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            // ✅ Extract URL from JSON response
            if let urlString = json?["url"] as? String {
                return URL(string: urlString)
            } else {
                throw FetchDataError.jsonDecodingError(NSError(domain: "URL not found in response", code: 404, userInfo: nil))
            }
            
        } catch {
            throw FetchDataError.networkError(error)
        }
    }


    
}

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

   
    
    func fetchData(authToken: String, platformCode: String, isStaging : Bool) async throws -> (Bool, ClientDetails?) {
        let environment = "staging" // Change this based on your environment
        let apiUrl  : String
        if isStaging {
            apiUrl = "https://api.staging.voltmoney.in/app/pf/details/"
        } else {
            apiUrl = "https://api.voltmoney.in/app/pf/details/"
        }
        let voltPlatformCode = platformCode // Replace with your actual platform code
        let platformAuthToken = authToken// Replace with your actual auth token

        guard let url = URL(string: apiUrl) else {
            throw FetchDataError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(voltPlatformCode, forHTTPHeaderField: "X-AppPlatform")
        request.setValue("Bearer \(platformAuthToken)", forHTTPHeaderField: "Authorization")

        let (data, response): (Data?, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw FetchDataError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw FetchDataError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw FetchDataError.statusCodeError(httpResponse.statusCode)
        }

        guard let jsonData = data else {
            throw FetchDataError.noData
        }
        let decoder = JSONDecoder()
        
        do {
            let model = try decoder.decode(ClientDetails.self, from: jsonData)
            return (true, model)
        }
        catch {
            print ("an error in catch")
            print (error)
            throw FetchDataError.jsonDecodingError(error)
        }
//        
//
//        do {
//            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? AnyObject
//            print(json)
//            return (true, json)
//        } catch {
//            throw FetchDataError.jsonDecodingError(error)
//        }
        
        // Above code is commented for Serialize a JSON object in the later stages ,its a sort of a TODO
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
    
}

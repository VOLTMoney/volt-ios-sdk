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

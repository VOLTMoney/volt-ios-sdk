//
//  VoltInstance.swift
//  VoltFramework
//
//  Created by Sagar Bhatnagar 26/03/24
//

import Foundation

public class VoltInstance {
    let partner_platform: String?
    let primary_color: String?
    let secondary_color: String?
    let ref: String?
    var voltEnv: VOLTENV?
    let ssoToken : String
    let customerCode : String
    let target : String?

    public init(voltEnv: VOLTENV? = nil, partner_platform: String?, primary_color: String? = nil, secondary_color: String? = nil, ref: String? = nil, ssoToken : String? = "", customerCode : String? = "", target : String? = "") {
        if voltEnv == nil {
            self.voltEnv = .STAGING
        } else {
            self.voltEnv = voltEnv
        }
        self.partner_platform = partner_platform
        self.primary_color = primary_color
        self.secondary_color = secondary_color
        self.target = target
        self.ref = ref
        self.ssoToken = ssoToken!
        self.customerCode = customerCode!
    }
    
}

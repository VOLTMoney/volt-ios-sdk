//
//  VoltInstance.swift
//  VoltFramework
//
//  Created by R.P.Kumar.Mishra on 10/02/23.
//

import Foundation

public class VoltInstance {
    let app_key: String?
    let app_secret: String?
    let partner_platform: String?
    let primary_color: String?
    let secondary_color: String?
    let ref: String?
    var voltEnv: VOLTENV?

    public init(voltEnv: VOLTENV? = nil, app_key: String?, app_secret: String?, partner_platform: String?, primary_color: String? = nil, secondary_color: String? = nil, ref: String? = nil) {
        if voltEnv == nil {
            self.voltEnv = .STAGING
        } else {
            self.voltEnv = voltEnv
        }
        self.app_key = app_key
        self.app_secret = app_secret
        self.partner_platform = partner_platform
        self.primary_color = primary_color
        self.secondary_color = secondary_color
        self.ref = ref
    }
}

//
//  VoltInstance.swift
//  VoltFramework
//
//  Created by R.P.Kumar.Mishra on 10/02/23.
//

import Foundation

public class VoltInstance {
    let appKey: String?
    let appSecret: String?
    let partnerPlatform: String?
    let primaryColor: String?
    let secondaryColor: String?
    let ref: String?

    public init(appKey: String?, appSecret: String?, partnerPlatform: String?, primaryColor: String? = nil, secondaryColor: String? = nil, ref: String? = nil) {
        self.appKey = appKey
        self.appSecret = appSecret
        self.partnerPlatform = partnerPlatform
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.ref = ref
    }
}

//
//  InfoModel.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 06/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class InfoModel: Object {
    @objc dynamic var cpuUsage = String.empty
    @objc dynamic var memoryUsed = String.empty
    @objc dynamic var deviceInfo = String.empty
    @objc dynamic var onDate = String.empty
    @objc dynamic var batteryLevel = String.empty

    init(cpuUsage: String,
         memoryUsed: String,
         batteryLevel: String,
         date: String,
         deviceInfo: String) {
        super.init()
        self.cpuUsage =  cpuUsage
        self.memoryUsed =  memoryUsed
        let encryptValue = CommonUtils.encryptMessage(message: date,
                                                      encryptionKey: Constants.Encryption.key,
                                                      iv: Constants.Encryption.iv) ?? String.empty
        self.onDate = encryptValue
        self.batteryLevel = batteryLevel
        self.deviceInfo = deviceInfo
    }

    /// Override Realm init method to complete cycle
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    /// Override Realm init method to complete cycle
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    /// Override Realm init method to complete cycle
    required init() {
        super.init()
    }
}

//
//  LocationModel.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 06/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift
import Realm

class LocationModel: Object {

    @objc dynamic var latitude = Double.empty
    @objc dynamic var longitude = Double.empty
    @objc dynamic var onDate = String.empty
    @objc dynamic var address = String.empty

    init(_ location: CLLocationCoordinate2D,
         date: String,
         address: String) {
        super.init()
        self.latitude =  location.latitude
        self.longitude =  location.longitude
        let encryptValue = CommonUtils.encryptMessage(message: date,
                                                      encryptionKey: Constants.Encryption.key,
                                                      iv: Constants.Encryption.iv) ?? String.empty
        self.onDate = encryptValue
        self.address = address
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

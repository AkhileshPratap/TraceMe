//
//  AppDelegate+Realm.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 07/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Realm
extension AppDelegate {

    func configureRealm() {
        //Realm Db Configuration
        //Note: Need to update the schema version if there is chnage in DB models
        //(For App Store Submission and also uncommnent the migrateAppDatabaseForNewVerion method)
        let currentRealmSchemaVersion: UInt64 = 0
        let config = Realm.Configuration (
            schemaVersion: currentRealmSchemaVersion)
        Realm.Configuration.defaultConfiguration = config
        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
            Logger.log.info(fileURL)
        } else {
            Logger.log.info("Realm : Failed to get file URL")
        }
        //To migrate the realn db schema
        migrateAppDatabaseForNewVerion(updateVersionNumber: currentRealmSchemaVersion)
    }

    // MARK: Realm DB Migration
    func migrateAppDatabaseForNewVerion( updateVersionNumber: UInt64 ) {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: updateVersionNumber,
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { _/*migration*/, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if oldSchemaVersion < updateVersionNumber {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}


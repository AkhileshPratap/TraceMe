//
//  RealmDBInterface.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 07/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


protocol LocalDBInterface {
    associatedtype DBObject

    /// Delete all objects of the same type and add given object
    func addObject(object: DBObject)

    /// Get all objects of the given type
    func getObjects(object: DBObject.Type) -> [DBObject]?

//    /// Delete all objects
//    func deleteObjects(object: DBObject.Type)
//
//    /// Delete given object only
//    func deleteObject(object: DBObject)

    /// Perform safe update on DBObject inside the write block
    func performUpdateOnDBObject(_ writeBlock: () -> Void)
}


public class MyRealms {
    // swiftlint:disable force_try
    public static var main: Realm = try! Realm()
    // swiftlint:enable force_try
}

class RealmDBInterface: LocalDBInterface {
    typealias DBObject = Object

    /// Get realm object inside the write transaction
    func getRealmObjectInsideWriteTransaction(_ writeBlock: (_ realm: Realm) -> Void) {
        do {
            let realm = MyRealms.main
            try realm.write {
                writeBlock(realm)
            }
        } catch let err {
            Logger.log.error("Realm Error \(err)")
        }
    }

    func getObjects(object: DBObject.Type) -> [DBObject]? {
        let realm = MyRealms.main
        let objects = realm.objects(object)
        if objects.count > 0 {
            let array = Array(objects)
            return array
        }
        return nil
    }

//    func deleteObject(object: DBObject) {
//        if object.isInvalidated == false {
//            getRealmObjectInsideWriteTransaction { (realm) in
//                realm.cascadingDelete(object: object)
//            }
//        }
//    }
//
//    func deleteObjects(object: DBObject.Type) {
//        getRealmObjectInsideWriteTransaction { (realm) in
//            realm.cascadingDelete(object: realm.objects(object))
//        }
//    }

    func performUpdateOnDBObject(_ writeBlock: () -> Void) {
        do {
            let realm = MyRealms.main
            try realm.write {
                writeBlock()
            }
        } catch let err {
            Logger.log.error("Realm Error \(err)")
        }
    }

    func addObject(object: DBObject) {
        getRealmObjectInsideWriteTransaction { (realm) in
            if object.isInvalidated == false {
                realm.add(object)
            }
        }
    }

    func addObjects(objects: [DBObject]) {
        getRealmObjectInsideWriteTransaction { (realm) in
            realm.add(objects)
        }
    }

//    func removeAllThenAddObjects(objects: [DBObject]) {
//        getRealmObjectInsideWriteTransaction { (realm) in
//            if let first = objects.first {
//                realm.cascadingDelete(object: realm.objects(type(of: first)))
//            }
//            realm.add(objects)
//        }
//    }

    func printHello() {
        Logger.log.info("--> hello")
    }
}

//extension Realm {
//    func writeAsync<T : ThreadConfined>(obj: T, errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return }, block: @escaping ((Realm, T?) -> Void)) {
//        let wrappedObj = ThreadSafeReference(to: obj)
//        let config = self.configuration
//        DispatchQueue(label: "background").async {
//            autoreleasepool {
//                do {
//                    let realm = try Realm(configuration: config)
//                    let obj = realm.resolve(wrappedObj)
//
//                    try realm.write {
//                        block(realm, obj)
//                    }
//                }
//                catch {
//                    errorHandler(error)
//                }
//            }
//        }
//    }
//}


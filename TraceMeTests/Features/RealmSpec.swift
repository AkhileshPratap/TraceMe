//
//  RealmSpec.swift
//  TraceMeTests
//
//  Created by Akhilesh Singh on 09/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import Nimble
import Quick
import RealmSwift

@testable import TraceMe

class RealmSpec: QuickSpec {
    override func spec() {

        let interface = RealmDBInterface()
        describe("RealmDBInterface") {

            context("when save an object", {
                it("should save object") {
                    interface.addObject(object: MockLocationModel.data[0])
                }

                it("should match with object") {
                    let lastSaveLocation = getLocationObject()
                    expect(lastSaveLocation?.address).to(equal(MockLocationModel.data[0].address))

                }
            })
        }
    }
}

func getLocationObject() -> LocationModel? {
    if let object = RealmDBInterface().getObjects(object: LocationModel.self) as? [LocationModel] {
        return object.last
    }
    return nil
}


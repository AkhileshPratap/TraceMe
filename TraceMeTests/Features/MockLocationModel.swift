//
//  MockLocationModel.swift
//  TraceMeTests
//
//  Created by Akhilesh Singh on 09/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import Foundation
import CoreLocation

@testable import TraceMe

struct MockLocationModel {
    static var data: [LocationModel] {
        let model1 = LocationModel(CLLocationCoordinate2DMake(19.0176147, 19.0176147),
                                  date: Date().toString(format: Constants.DataFormatter.dateFormatUTC),
                                  address: "Noida")

        let model2 = LocationModel(CLLocationCoordinate2DMake(19.0176147, 19.0176147),
                                  date: Date().toString(format: Constants.DataFormatter.dateFormatUTC),
                                  address: "Pune")

        return [model1, model2]
    }
}

struct MockInfoModel {
    static var data: InfoModel {
        let infoModel = InfoModel(cpuUsage: "10.0",
                               memoryUsed: "2%",
                               batteryLevel: "100%",
                               date: Date().toString(format: Constants.DataFormatter.dateFormatUTC),
                               deviceInfo: "iOS")

        return infoModel
    }
}

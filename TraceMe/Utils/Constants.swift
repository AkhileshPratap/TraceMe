//
//  Constants.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 07/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit

class Constants: NSObject {

    struct Encryption {
        static let key = "mykeymykeymykey1"
        static let iv = "myivmyivmyivmyiv"
    }

    struct DataFormatter {
        static let dateFormatDDMMMYYYYWithTime = "dd MMM, yyyy, hh:mm a"
        static let dateFormatUTC = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    }

    struct Timer {
        static let backgroundTimer = 10.0
        static let updateSaveTimer = 10
        static let geocoderTimeout = 10
    }

}

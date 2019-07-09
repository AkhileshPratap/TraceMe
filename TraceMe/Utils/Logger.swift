//
//  Logger.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 07/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit
import XCGLogger

class Logger: NSObject {

    static let log: XCGLogger = {

        let log = XCGLogger.default
        log.setup(level: .debug,
                  showThreadName: true,
                  showLevel: true,
                  showFileNames: true,
                  showLineNumbers: true,
                  writeToFile: nil,
                  fileLevel: .debug)

        //let log = XCGLogger(identifier: "Logger", includeDefaultDestinations: false)

        //configuration options
        #if DEBUG
        log.outputLevel = .debug
        #else
        log.outputLevel = .none
        #endif

        //Add basic app info, version info etc, to the start of the logs
        log.logAppDetails()
        return log
    }()
}

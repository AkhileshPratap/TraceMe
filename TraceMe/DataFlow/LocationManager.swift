//
//  LocationManager.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 08/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit

import Foundation
import CoreLocation
import UIKit
import RealmSwift

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    fileprivate let locationManager = CLLocationManager()
    private var timer: Timer?
    private var currentTaskId: UIBackgroundTaskIdentifier?
    private var lastLocationDate: Date = Date()

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.activityType = .other
        locationManager.distanceFilter = kCLDistanceFilterNone
        if #available(iOS 9, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.applicationEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }

    @objc func applicationEnterBackground() {
        Logger.log.info("applicationEnterBackground")
        start()
    }

    public func start() {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
            if #available(iOS 9, *) {
                locationManager.requestLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    @objc func restart() {
        print("====================restart=====================")
        timer?.invalidate()
        timer = nil
        start()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.restricted:
            Logger.log.info("Restricted Access to location")
        case CLAuthorizationStatus.denied:
            Logger.log.info("User denied access to location")
        case CLAuthorizationStatus.notDetermined:
            Logger.log.info("Status not determined")
        default:
            Logger.log.info("start Updating Location")
            if #available(iOS 9, *) {
                locationManager.requestLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(timer == nil) {
            guard locations.last != nil else { return }

            beginBackgroundTask()
            locationManager.stopUpdatingLocation()
            Logger.log.info(manager)
            let currentDate = Date()
            if isItTime(currentDate: currentDate) {
                if let lastLocation = locations.last {
                    let coder: Geocoder = Geocoder()
                    coder.geocode(location: lastLocation,
                                  queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background)) {[weak self] (location, address) in
                                    Logger.log.info(address)
                                    if let locationAddress = address {
                                        self?.saveLocationToDB(location: lastLocation,
                                                               currentDate: currentDate,
                                                               address: locationAddress)
                                    }
                    }
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        beginBackgroundTask()
        locationManager.stopUpdatingLocation()
    }

    private func isItTime(currentDate: Date) -> Bool {
        let timePast = currentDate.timeIntervalSince(lastLocationDate)
        let intervalExceeded = Int(timePast) > Constants.Timer.updateSaveTimer
        return intervalExceeded;
    }

    private func saveLocationToDB(location: CLLocation, currentDate: Date, address: String) {

        DispatchQueue.global().async {[weak self] in
            let locationModel: LocationModel = LocationModel(location.coordinate,
                                                             date: currentDate.toString(format: Constants.DataFormatter.dateFormatUTC),
                                                             address: address)
            let realm = try! Realm()
            try! realm.write {
                realm.add(locationModel)
            }

            self?.saveDeviceInfoToDB(currentDate: currentDate)
        }
    }

    private func saveDeviceInfoToDB(currentDate: Date) {
        let deviceManager = DeviceManager()
        let info: InfoModel = InfoModel(cpuUsage: deviceManager.getCPULoadInfo(),
                                        memoryUsed: deviceManager.getMemoryStatus(),
                                        batteryLevel: deviceManager.getBatteryLevel(),
                                        date: currentDate.toString(format: Constants.DataFormatter.dateFormatUTC),
                                        deviceInfo: deviceManager.getDeviceInfo())

        let realm = try! Realm()
        try! realm.write {
            realm.add(info)
        }

    }

    private func beginBackgroundTask() {
        var previousTaskId = currentTaskId
        currentTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            Logger.log.info("Task Expired")
        })
        if let taskId = previousTaskId {
            UIApplication.shared.endBackgroundTask(taskId)
            previousTaskId = UIBackgroundTaskIdentifier.invalid
        }

        timer = Timer.scheduledTimer(timeInterval: Constants.Timer.backgroundTimer,
                                     target: self,
                                     selector: #selector(self.restart),
                                     userInfo: nil,
                                     repeats: false)
    }
}

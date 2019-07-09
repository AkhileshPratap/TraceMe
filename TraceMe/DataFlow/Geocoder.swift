//
//  Geocoder.swift
//  LocationManager
//
//  Created by Ankit Thakur on 11/09/16.
//  Copyright © 2016 Ankit Thakur. All rights reserved.
//

import Foundation
import CoreLocation

internal typealias GeocoderCallback =  (_ location: CLLocation?, _ address: String?) -> Void

internal class Geocoder: NSObject {
    
    var location: CLLocation?
    var goeCoderCallback: GeocoderCallback?
    var geoCoder: CLGeocoder?
    var address: String = String.empty
    
    func geocode(location: CLLocation,
                 queue: DispatchQueue,
                 callBack: @escaping GeocoderCallback) {
        
        self.location = location
        goeCoderCallback = callBack
        
        geoCoder = CLGeocoder()

        let group: DispatchGroup = DispatchGroup()
        
        group.enter()
        
        let timeout: DispatchTime = DispatchTime(uptimeNanoseconds: UInt64(Constants.Timer.geocoderTimeout * 1000))
        
        geoCoder?.reverseGeocodeLocation(location,
                                         completionHandler: { [weak self] (placemarks: [CLPlacemark]?, error: Error?) in

                                            if error != nil {
                                                print("Reverse geocode Location failed, Error: \(error!.localizedDescription)")
                                            }
                                            if let placemarks = placemarks , placemarks.count > 0 {
                                                let placemark = placemarks[0]
                                                let address = [placemark.name, placemark.subLocality, placemark.locality].compactMap {$0}.joined(separator: ", ")
                                                self?.address = address
                                            }
                                            group.leave()
        })
        
        _ = group.wait(timeout: timeout)

        group.notify(queue: queue) {
            queue.async {
                self.goeCoderCallback!(self.location, self.address)
            }
        }

    }

}

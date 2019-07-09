//
//  Extensions.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 06/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    func dequeueReusableCell<T: UITableViewCell>(cell: T.Type) -> T? {
        return self.dequeueReusableCell(withIdentifier: cell.identifier()) as? T
    }

    func registerNib<T: UITableViewCell>(cell: T.Type) {
        self.register(cell.nibForCell(), forCellReuseIdentifier: cell.identifier())
    }

}

extension UITableViewCell {
    class func nibForCell() -> UINib {
        return UINib(nibName: self.identifier(), bundle: nil)
    }
}

extension UIView {
    /// Return the class of View in string
    class func identifier() -> String {
        return "\(self)"
    }

    func roundCorner(_ radius:CGFloat = 0.0){
        self.layer.cornerRadius = (radius != 0.0) ? radius : self.bounds.size.width/2
        self.layer.masksToBounds = true
    }

    func dropShadow() {
        self.layer.shadowOpacity = 0.18
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
    }
}

extension Date {
    func string(formatterString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatterString
        
        return dateFormatter.string(from: self)
    }

    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    static func dateFromServerString(dateString: String?) -> Date? {
        guard let strValue = dateString else { return nil }
        let stringFormatArray = [Constants.DataFormatter.dateFormatUTC]
        for formatString in stringFormatArray {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formatString
            if let date = dateFormatter.date(from: strValue) {
                return date
            }
        }
        return nil
    }
}

extension String {
    static var empty: String { return "" }
}

extension Double {
    static var empty: Double { return 0.00 }
}

//
//  GenericBaseTableViewCell.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 06/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit

class GenericBaseTableViewCell: UITableViewCell {

    var representedObject: Any? {
        didSet {
            if representedObject != nil {
                bind()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func bind() {
        fatalError("Must Override")
    }
}

//
//  DashboardInfoCell.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 06/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit

protocol DashboardInfoCellProtocol {
    var title: String { get }
    var subTitle: String { get }
    var detail: String { get }
    var description: String { get }
}

class DashboardInfoCell: GenericBaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.black
            titleLabel.font = UIFont.systemFont(ofSize: 16)
        }
    }

    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.textColor = UIColor.gray
            subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        }
    }

    @IBOutlet weak var detailLabel: UILabel! {
        didSet {
            detailLabel.textColor = UIColor.gray
            detailLabel.font = UIFont.systemFont(ofSize: 14)
        }
    }

    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.textColor = UIColor.gray
            descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        }
    }

    @IBOutlet weak var bgView: UIView! {
        didSet {
            bgView.layer.borderWidth = 0.8
            bgView.layer.borderColor = UIColor.lightGray.cgColor
            bgView.roundCorner(10.0)
            bgView.dropShadow()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func bind() {
        guard let model = self.representedObject as? DashboardInfoCellProtocol else { return }

        self.titleLabel.text = model.title
        self.subTitleLabel.text = model.subTitle
        self.detailLabel.text = model.detail
        self.descriptionLabel.text = model.description

    }
    
}

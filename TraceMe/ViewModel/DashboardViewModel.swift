//
//  DashboardViewModel.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 06/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import UIKit
import RealmSwift

protocol GenericTableViewBaseModel {
    var cellType: GenericBaseTableViewCell.Type { get set }
}

class DashboardViewModel: NSObject {

    private var dataSource: [GenericTableViewBaseModel] = []

    var locationList: [LocationModel]?
    var infoModel: InfoModel?
    var token: NotificationToken?
    var reloadData: (()->())?

    // MARK: - Helper
    public func numberOfSection() -> Int {
        return 1
    }

    /// get number of rows
    public func numberOfRows(section: Int) -> Int {
        return dataSource.count
    }

    public func itemForRow(indexPath: IndexPath) -> GenericTableViewBaseModel? {
        if indexPath.row >= dataSource.count {
            return nil
        }
        return dataSource[indexPath.row]
    }

    /// get cell type
    public func allCellTypes() -> [GenericBaseTableViewCell.Type] {
        return [DashboardInfoCell.self]
    }

    /// This func is used to prepare data source
    public func ifDataAvailableToPrepareDataSource() -> Bool {
        self.dataSource.removeAll()
        guard let locationList = self.locationList, let infoData = self.infoModel else {
            return false
        }

        /// get data source
        var mapData = locationList.map { DashboardCellModel(cellType: DashboardInfoCell.self, dataModel: $0) }
        mapData.insert(DashboardCellModel(cellType: DashboardInfoCell.self, dataModel: infoData), at: 0)
        dataSource.append(contentsOf: mapData)

        return true
    }

    public func getDataFromDataBase() {
        prepareForLocationData()
        prepareForInfoData()
    }

    /// prepare local data
    private func prepareForLocationData() {
        if let dataList = getLocationObjects() {
            self.locationList = dataList
        }
    }

    private func prepareForInfoData() {
        if let data = getInfoObject() {
            self.infoModel = data
        }
    }

    private func getLocationObjects() -> [LocationModel]? {
        if let object = RealmDBInterface().getObjects(object: LocationModel.self) as? [LocationModel] {
            return object
        }
        return nil
    }

    private func getInfoObject() -> InfoModel? {
        if let object = RealmDBInterface().getObjects(object: InfoModel.self) as? [InfoModel] {
            return object.last
        }
        return nil
    }

    // Realm Notifier
    func getDataFromRealm() {
        let realm = try! Realm()
        token = realm.objects(InfoModel.self)._observe({ [weak self] changes in
            switch changes {
            case .initial(_):
                self?.reloadData?()
                break
            case .update(_):
                self?.reloadData?()
                break
            case .error(let err):
                fatalError("\(err)")
                break
            }
        })
    }
}

class DashboardCellModel: DashboardInfoCellProtocol, GenericTableViewBaseModel {
    
    var cellType: GenericBaseTableViewCell.Type
    var title: String = ""
    var description: String = ""
    var subTitle: String = ""
    var detail: String = ""
    
    init(cellType: GenericBaseTableViewCell.Type) {
        self.cellType = cellType
    }

    convenience init(cellType: GenericBaseTableViewCell.Type, dataModel: LocationModel) {
        self.init(cellType: cellType)
        self.title = "Address: " + dataModel.address
        self.subTitle = "Latitude: " + String(dataModel.latitude)
        self.detail = "Longitude: " + String(dataModel.longitude)
         let decryptedValue = CommonUtils.decryptMessage(encryptedMessage: dataModel.onDate,
                                                         encryptionKey: Constants.Encryption.key,
                                                         iv: Constants.Encryption.iv)

        if let actualDate = Date.dateFromServerString(dateString: decryptedValue) {
            self.description = "On Date: " + actualDate.string(formatterString: Constants.DataFormatter.dateFormatDDMMMYYYYWithTime)
        }

    }

    convenience init(cellType: GenericBaseTableViewCell.Type, dataModel: InfoModel) {
        self.init(cellType: cellType)
        self.title = "Device Info: " + dataModel.deviceInfo
        self.subTitle = "RAM: " + dataModel.memoryUsed
        self.detail = "CPU: " + dataModel.cpuUsage
        let decryptedValue = CommonUtils.decryptMessage(encryptedMessage: dataModel.onDate,
                                                        encryptionKey: Constants.Encryption.key,
                                                        iv: Constants.Encryption.iv)

        if let actualDate = Date.dateFromServerString(dateString: decryptedValue) {
            self.description = "Battery Level: " + dataModel.batteryLevel + " on date: " + actualDate.string(formatterString: Constants.DataFormatter.dateFormatDDMMMYYYYWithTime)
        }

    }
}

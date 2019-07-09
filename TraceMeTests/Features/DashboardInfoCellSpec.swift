//
//  DashboardInfoCellSpec.swift
//  TraceMeTests
//
//  Created by Akhilesh Singh on 09/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import Nimble
import Quick

@testable import TraceMe

class UsersListItemCellViewModelSpec: QuickSpec {
    override func spec() {
        let cellModelForLocation = DashboardCellModel(cellType: DashboardInfoCell.self, dataModel: MockLocationModel.data[0])
        
        let cellModelForInfo = DashboardCellModel(cellType: DashboardInfoCell.self, dataModel: MockInfoModel.data)
        
        describe("Given a location item") {
            it("should display address") {
                expect(cellModelForLocation.title).to(equal("Address: Noida"))
            }
            
            it ("should display battery level") {
                expect(cellModelForInfo.title).to(equal("Device Info: iOS"))
            }
        }
    }
}

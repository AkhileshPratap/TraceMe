//
//  DashboardViewModelSpec.swift
//  TraceMeTests
//
//  Created by Akhilesh Singh on 09/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//


import Nimble
import Quick

@testable import TraceMe

class DashboardViewModelSpec: QuickSpec {
    override func spec() {
        let viewModel = DashboardViewModel()
        viewModel.locationList = MockLocationModel.data
        viewModel.infoModel = MockInfoModel.data

        describe("Given results") {
            beforeEach {
                _ = viewModel.ifDataAvailableToPrepareDataSource()
            }

            it("should show the correct location") {
                expect(viewModel.locationList![0].address).to(equal("Noida"))
            }

            it("should show the correct info") {
                expect(viewModel.infoModel!.deviceInfo).to(equal("iOS"))

            }
        }
    }
}

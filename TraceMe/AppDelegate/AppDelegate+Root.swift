//
//  AppDelegate+Root.swift
//  TraceMe
//
//  Created by Akhilesh Singh on 09/07/19.
//  Copyright © 2019 Akhilesh Singh. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {

    ///This function is used to set the root view controller of Window inside the Navigation controller
    func setRootController() {
        let viewController = self.getRootViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    ///This function is used to get the root view controller for window
    ///
    /// - Returns: returns the view controller on the basis of access code
    func getRootViewController() -> UIViewController {
        let controller = DashboardViewController()
        let navigationController = UINavigationController(rootViewController: controller)

        return navigationController
    }
}

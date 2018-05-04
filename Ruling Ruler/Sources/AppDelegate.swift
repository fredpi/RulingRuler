//
//  AppDelegate.swift
//  Ruling Ruler
//
//  Created by Frederick Pietschmann on 04.11.17.
//  Copyright © 2017-2018 Piknotech. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Properties
    var window: UIWindow?

    // MARK: - Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Do configuration
        FabricManager.shared.start()
        InstallationManager.shared.store()

        // Load view controller
        window = UIWindow(frame: UIScreen.main.bounds)
        var rootVc: UIViewController = MainViewController.shared

        if DimensionInfo.pixelsPerInch == nil {
            rootVc = ErrorViewController()
            FabricManager.shared.log(.unknownDevice)
        }

        window!.rootViewController = rootVc
        window!.makeKeyAndVisible()

        // Enter screenshot creation mode
        // ScreenshotManager.shared.takeover()
        // return true

        // Show tutorial
        let tutorialShown = TutorialManager.shared.showTutorialIfNeeded(on: MainViewController.shared)

        // Request review
        if !tutorialShown {
            AppReviewManager.shared.request()
        }

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        AppReviewManager.shared.request()
    }
}
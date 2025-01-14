//
//  FabricManager.swift
//  Ruling Ruler
//
//  Created by Frederick Pietschmann on 01.05.18.
//  Copyright © 2017-2018 Piknotech. All rights reserved.
//

import Crashlytics
import Fabric
import Foundation

final class FabricManager {
    // MARK: - Subtypes
    enum Event {
        case unknownDevice
        case sidesSwitched
    }

    // MARK: - Properties
    static let shared = FabricManager()
    private var isRunning = false

    // MARK: - Initializers
    private init() { }

    // MARK: - Methods
    func start() {
        if !isRunning {
            // Checking for apikey should also happen in non-prod mode
            guard let url = Bundle.main.url(forResource: "fabric.apikey", withExtension: nil) else {
                print("No fabric.apikey file found. If this is a release build, make sure to add it to target.")
                return
            }

            guard let fabricApiKey = try? String(contentsOf: url).trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("Unable to read fabric.apikey file. If this is a release build, make sure to fix this error.")
                return
            }

            if VersionInfo.isProdMode {
                Crashlytics.start(withAPIKey: fabricApiKey)
                Fabric.with([Crashlytics.self, Answers.self])
                isRunning = true
            }
        }
    }

    func log(_ event: Event) {
        if isRunning {
            switch event {
            case .unknownDevice:
                logUnknownDevice()

            case .sidesSwitched:
                logSidesSwitched()
            }
        }
    }

    // MARK: Logging Helpers
    private func logUnknownDevice() {
        Answers.logCustomEvent(withName: "Unknown device")
        Answers.logCustomEvent(withName: "Unknown device: \(DeviceInfo.modelIdentifier)")
    }

    private func logSidesSwitched() {
        Answers.logCustomEvent(withName: "Sides switched")
    }
}

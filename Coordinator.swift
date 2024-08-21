//
//  Coordinator.swift
//  MphasisWeatherApp
//
//  Created by PSingh on 8/21/24.
//

import Foundation
import UIKit
import SwiftUI

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {

    private let presentingNavigationController: UINavigationController

    init(
        presentingNavigationController: UINavigationController
    ) {
        self.presentingNavigationController = presentingNavigationController
    }
    
    func start() {
        let contentView = WeatherView()
        let hostingController = UIHostingController(rootView: contentView)
        presentingNavigationController.viewControllers = [hostingController]
    }
}

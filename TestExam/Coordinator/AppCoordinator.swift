//
//  AppCoordinator.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewModel = NewsListViewModel(repository: NewsRepositoryImpl())
        let viewController = NewsListViewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: viewController)

        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
}

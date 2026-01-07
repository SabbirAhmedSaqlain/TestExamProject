//
//  SceneDelegate.swift
//  TestExam
//
//  Created by Sabbir on 1/6/26.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .white
        window.overrideUserInterfaceStyle = .light
        let coordinator = AppCoordinator(window: window)
        coordinator.start()

        self.window = window
        self.appCoordinator = coordinator
    }
}

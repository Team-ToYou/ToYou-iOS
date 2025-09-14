//
//  SceneDelegate.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
        
        if nil == KeychainService.get(key: K.Key.accessToken) {
            RootViewControllerService.toLoginViewController()
        }
        // 토큰 검증 후 적절한 화면으로 이동
        validateAndNavigate()
        return
    }
    
    private func validateAndNavigate() {
        guard KeychainService.get(key: K.Key.accessToken) != nil else {
            RootViewControllerService.toLoginViewController()
            return
        }
        
        AuthAPIService.isUserFinishedSignUp { code in
            DispatchQueue.main.async {
                switch code {
                case .finished:
                    RootViewControllerService.toBaseViewController()
                case .notFinished:
                    RootViewControllerService.toSignUpViewController()
                case .expired:
                    self.handleTokenExpiration()
                case .error:
                    RootViewControllerService.toLoginViewController()
                }
            }
        }
    }

    private func handleTokenExpiration() {
        AuthAPIService.reissueRefreshToken { code in
            DispatchQueue.main.async {
                switch code {
                case .success:
                    self.validateAndNavigate() // 재귀적으로 다시 검증
                case .expired, .error:
                    RootViewControllerService.toLoginViewController()
                }
            }
        }
    }
    
    func changeRootViewController(_ viewController: UIViewController, animated: Bool) {
        guard let window = self.window else { return }       
        window.rootViewController = viewController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


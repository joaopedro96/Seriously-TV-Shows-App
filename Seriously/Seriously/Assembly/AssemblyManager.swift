//
//  AssemblyManager.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 23/11/21.
//

import UIKit

class AssemblyManager {
    
    // MARK: - REQUIRED MANAGERS
    
    private var flowManager: FlowManager?
    private var urlSessionManager = URLSessionManager()
//    private let requestServiceManager: RequestServiceManager = RequestServiceManager()
    
    // MARK: - INITIALIZERS
    
    init() {
        startFlowManager()
    }
    
    // MARK: - PUBLIC METHODS
    
    public func makeAssembly() -> UIViewController? {
        return flowManager?.setupMainView()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func startFlowManager() {
        let flowManager = FlowManager(homeViewController: makeHomeViewController(),
                                      favoritesViewController: makeFavoritesViewController(),
                                      tabBarViewController: makeTabBarViewController())
        self.flowManager = flowManager
    }
    
    // MARK: - SETUP VIEW CONTROLLERS
    
    private func makeTabBarViewController() -> MainTabBarController {
        return MainTabBarController()
    }
    
    private func makeHomeViewController() -> HomeViewController {
        let homeViewModel = HomeViewModel(requestSession: RequestServiceManager(urlSessionManager: self.urlSessionManager))
        let viewController = HomeViewController(viewModel: homeViewModel)
        return viewController
    }

    private func makeFavoritesViewController() -> FavoritesViewController {
        let favoritesViewModel = FavoritesViewModel(requestSession: RequestServiceManager(urlSessionManager: self.urlSessionManager))
        let viewController = FavoritesViewController(viewModel: favoritesViewModel)
        return viewController
    }
}

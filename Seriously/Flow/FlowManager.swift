//
//  FlowManager.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 23/11/21.
//

import UIKit

class FlowManager {
    
    // MARK: - PROPERTIES
    
    let urlSessionManager: URLSessionManager
    let homeViewController: HomeViewController
    let favoritesViewController: FavoritesViewController
    let tabBarViewController: MainTabBarController
    
    // MARK: - INITIALIZERS
    
    init(urlSessionManager: URLSessionManager,
         homeViewController: HomeViewController,
         favoritesViewController: FavoritesViewController,
         tabBarViewController: MainTabBarController) {
        self.urlSessionManager = urlSessionManager
        self.homeViewController = homeViewController
        self.favoritesViewController = favoritesViewController
        self.tabBarViewController = tabBarViewController
    }
    
    // MARK: - PUBLIC METHODS
    
    public func setupMainView() -> UIViewController {
        homeViewController.delegate = self
        favoritesViewController.delegate = self
        tabBarViewController.viewControllers = [homeViewController, favoritesViewController]
        tabBarViewController.setupTabBarItems()
        return tabBarViewController
    }
    
    public func goToFlowManager(with favoriteData: FavoritesViewDataModel) {
        favoritesViewController.updateView(with: favoriteData)
    }
}

// MARK: - EXTENSIONS

extension FlowManager: HomeViewControllerProtocol {
    func goToDetailsPage(with tvShowTitle: String) {
        let viewModel = DetailsViewModel(requestSession: RequestServiceManager(urlSessionManager: self.urlSessionManager))
        let detailsViewController = DetailsViewController(tvShowTitle: tvShowTitle, viewModel: viewModel)
        detailsViewController.delegate = self
        self.tabBarViewController.present(detailsViewController, animated: true, completion: nil)
    }
}

extension FlowManager: FavoritesViewControllerProtocol { }

extension FlowManager: DetailsViewControllerProtocol { }

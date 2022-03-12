//
//  FlowManager.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 23/11/21.
//

import UIKit

class FlowManager {
    
    // MARK: - PROPERTIES
    
    let homeViewController: HomeViewController
    let favoritesViewController: FavoritesViewController
    let tabBarViewController: MainTabBarController
    
    // MARK: - INITIALIZERS
    
    init(homeViewController: HomeViewController,
         favoritesViewController: FavoritesViewController,
         tabBarViewController: MainTabBarController) {
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
}

// MARK: - EXTENSIONS

extension FlowManager: HomeViewControllerProtocol {
    func goToFlowManager(with favoriteData: FavoritesViewDataModel) {
        favoritesViewController.updateView(with: favoriteData)
    }
    
    func goToDetailsPage(with tvShowData: TvShowDetailsPlanData) {
        DispatchQueue.main.async {
            let viewModel = DetailsViewModel()
            let detailsViewController = DetailsViewController(detailsData: tvShowData, viewModel: viewModel)
            self.homeViewController.present(detailsViewController, animated: true, completion: nil)
        }
    }
}

extension FlowManager: FavoritesViewControllerProtocol { }

//
//  MainTabBarController.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 30/10/21.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - CONSTANTS
    
    private struct Constants {
        static let homeTabBarTitle = "Home"
        static let favoriteTabBarTitle = "Favs"
    }
    
    private enum Metrics {
        static let tabBarPadding: CGFloat = -1
        static let fontSizeMedium: CGFloat = 16
        //        static let barHeight: CGFloat = 200;
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
    }
    
    //    override func viewWillLayoutSubviews() {
    //        super.viewWillLayoutSubviews()
    //        self.tabBarController?.tabBar.frame.size.height = Metrics.barHeight
    //        self.tabBarController?.tabBar.frame.origin.y = view.frame.height - Metrics.barHeight
    //    }
    
    // MARK: - PUBLIC METHODS
    
    public func setupTabBarItems() {
        if let tabItems = tabBar.items {
            let tabMainPage = tabItems[0]
            tabMainPage.title = Constants.homeTabBarTitle
            tabMainPage.image = .systemHouseFillIcon.withRenderingMode(.alwaysOriginal).withTintColor(.gray500)
            tabMainPage.selectedImage = .systemHouseFillIcon.withRenderingMode(.alwaysOriginal).withTintColor(.sky100)
            tabMainPage.titlePositionAdjustment.vertical = tabMainPage.titlePositionAdjustment.vertical-(Metrics.tabBarPadding)
            
            let tabListPage = tabItems[1]
            tabListPage.title = Constants.favoriteTabBarTitle
            tabListPage.image = .systemHeartIcon.withRenderingMode(.alwaysOriginal).withTintColor(.gray500)
            tabListPage.selectedImage = .systemHeartFillIcon.withRenderingMode(.alwaysOriginal).withTintColor(.sky100)
            tabListPage.titlePositionAdjustment.vertical = tabListPage.titlePositionAdjustment.vertical-(Metrics.tabBarPadding)
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    func setupCustomTabBar() {
        view.backgroundColor = .indigo400
        UITabBar.appearance().barTintColor = .indigo400
        UITabBar.appearance().isTranslucent = false
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.roboto(ofSize: Metrics.fontSizeMedium, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.gray500], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.roboto(ofSize: Metrics.fontSizeMedium, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.sky100], for: .selected)
    }
}

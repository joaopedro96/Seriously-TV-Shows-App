//
//  FavoritesViewProtocols.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 02/03/22.
//

import UIKit

protocol FavoritesViewModelProtocol: AnyObject {
    func didGetSearchedData(with tvShowSearchedData: HomeViewDataModel)
    func didGetCarouselItemsData(with tvShowItems: [TvShowPlanData])
}

protocol FavoritesViewControllerProtocol: AnyObject {
    func goToFlowManager(with entity: FavoritesViewDataModel)
    func goToDetailsPage(with tvShowTitle: String)
}

protocol FavoritesViewProtocol: AnyObject {
    func getCarouselItems()
    func didTapTvShowPoster(with searchLink: String)
    func loadImage(from urlString: String) -> UIImage?
}

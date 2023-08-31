//
//  HomeViewProtocols.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 02/03/22.
//

import UIKit

protocol HomeViewModelProtocol: AnyObject {
    func didGetSearchedData(with tvShowSearchedData: HomeViewDataModel)
    func didGetHomeTableData(with tableViewData: [HomeViewDataModel])
}

protocol HomeViewControllerProtocol: AnyObject {
    func goToFlowManager(with favoriteData: FavoritesViewDataModel)
    func goToDetailsPage(with tvShowTitle: String)
}

protocol HomeViewProtocol: AnyObject {
    func goToHomeViewController(with favoriteData: FavoritesViewDataModel)
    func didTapTvShowPoster(with title: String)
    func didMakeSearch(for text: String, and searchedPage: Int)
    func updateCellPosterView(with urlImage: String) -> UIImage?
    func updateHomeTableView()
    func resetHomeTableView()
}

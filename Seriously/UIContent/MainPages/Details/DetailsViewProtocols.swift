//
//  DetailsViewProtocols.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 02/03/22.
//

import UIKit

protocol DetailsViewModelProtocol: AnyObject {
    func didGetDetailsData(with tvShowData: TvShowDetailsPlanData)
}

protocol DetailsViewControllerProtocol: AnyObject {
    func goToFlowManager(with favoriteData: FavoritesViewDataModel)
}

protocol DetailsViewProtocol: AnyObject {
    func loadImage(from urlString: String) -> UIImage?
    func goToDetailsViewController(with favoriteData: FavoritesViewDataModel)
}

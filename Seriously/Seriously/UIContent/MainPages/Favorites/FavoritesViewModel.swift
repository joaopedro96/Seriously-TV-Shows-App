//
//  FavoritesViewModel.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 27/11/21.
//

import UIKit

class FavoritesViewModel {
    
    // MARK: - CONSTANTS
    
    private enum Metrics {
        static let carouselPage: Int = 13
    }
    
    // MARK: - PROPERTIES
    
    let requestServiceManager: RequestServiceManager
    weak var delegate: FavoritesViewModelProtocol?
    
    // MARK: - INITIALIZERS
    
    init(requestSession: RequestServiceManager) {
        requestServiceManager = requestSession
        requestServiceManager.delegate = self
    }
    
    // MARK: - PUBLIC METHODS
    
    public func fetchCarouselItemsData() {
        requestServiceManager.fetchCarrouselData(for: Metrics.carouselPage)
    }
    
    public func fetchDetailsPageData(for searchLink: String) {
        requestServiceManager.fetchDetailsPageData(with: searchLink)
    }
    
    public func fetchSearchedTvShowData(for showTitle: String, and searchedPage: Int) {
        requestServiceManager.fetchSearchData(with: showTitle, and: searchedPage)
    }
    
    public func getImage(from urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: imageData)
    }
}

// MARK: - EXTENSIONS

extension FavoritesViewModel: RequestServiceProtocol {
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    func didGetSinglePageData(with tvShowList: [TvShowPlanData]) {
        delegate?.didGetCarouselItemsData(with: tvShowList)
    }

    func didGetDetailsData(with tvShowData: DetailsViewDataModel) {
        delegate?.didGetDetailsData(with: tvShowData.tvShowDetails)
    }
    
    func didGetSearchData(with tvShowSearchedData: HomeViewDataModel) {
        delegate?.didGetSearchedData(with: tvShowSearchedData)
    }
}

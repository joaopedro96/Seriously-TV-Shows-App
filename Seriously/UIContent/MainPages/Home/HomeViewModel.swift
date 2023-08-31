//
//  HomeViewModel.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 23/11/21.
//

import UIKit

class HomeViewModel {
    
    // MARK: - PROPERTIES
    
    private let requestServiceManager: RequestServiceManager
    weak var delegate: HomeViewModelProtocol?
    
    // MARK: - INITIALIZERS
    
    init(requestSession: RequestServiceManager) {
        requestServiceManager = requestSession
        requestServiceManager.delegate = self
    }
    
    // MARK: - PUBLIC METHODS
    
    public func fetchHomeTableViewData() {
        requestServiceManager.fetchHomePageData()
    }
    
    public func fetchSearchedTvShowData(for showTitle: String, and searchedPage: Int) {
        requestServiceManager.fetchSearchData(with: showTitle, and: searchedPage)
    }
    
    public func resetData() {
        requestServiceManager.resetHomePageTableView()
    }
    
    public func getImage(from urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: imageData)
    }
}

// MARK: - EXTENSIONS

extension HomeViewModel: RequestServiceProtocol {
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    func didGetHomeTableData(with tableViewData: [HomeViewDataModel]) {
        delegate?.didGetHomeTableData(with: tableViewData)
    }

    func didGetSearchData(with tvShowSearchedData: HomeViewDataModel) {
        delegate?.didGetSearchedData(with: tvShowSearchedData)
    }
}

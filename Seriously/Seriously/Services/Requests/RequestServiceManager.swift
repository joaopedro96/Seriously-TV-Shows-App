//
//  RequestServiceManager.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 03/11/21.
//

import UIKit

class RequestServiceManager {
    
    // MARK: - CONSTANTS
    
    private let tvShowsSourceURL = "https://www.episodate.com/api/"
    
    // MARK: - PROPERTIES
    
    weak var delegate: RequestServiceProtocol?
    private var urlSession = URLSessionManager()

    private var homeTableViewRowsData: [HomeViewDataModel] = []
    
    private var tvShowsPageIndex = 1
    private var isFetchingData: Bool = false
    private var serviceState: RequestServiceState = .emptyState
    private var fetchHomeQueueState: RequestServiceHomeFetchQueueState = .emptyQueue
    
    // MARK: - INITIALIZERS
    
    init(urlSessionManager: URLSessionManager) {
        self.urlSession = urlSessionManager
    }
    
    // MARK: - PUBLIC METHODS
    
    public func fetchHomePageData() {
        if !isFetchingData {
            isFetchingData = true
            fetchHomeQueueState = .fetchingRowsData
            fetchDataForHomeTableViewRows()
        }
    }
    
    public func resetHomePageTableView() {
        if !isFetchingData {
            tvShowsPageIndex = 1
            fetchHomePageData()
        }
    }
    
    public func fetchCarrouselData(for page: Int) {
        isFetchingData = true
        serviceState = .fetchingFavoritesCarrouselData
        let stringNumber = String(page)
        let urlString: String = "\(tvShowsSourceURL)most-popular?page=\(stringNumber)"
        fetchHomeData(with: urlString)
    }
    
    public func fetchSearchData(with searchedText: String, and page: Int = 1) {
        isFetchingData = true
        serviceState = .fetchingSearchData
        let urlString: String = "\(tvShowsSourceURL)search?q=\(searchedText)&page=\(page)"
        fetchHomeData(with: urlString)
    }
    
    public func fetchDetailsPageData(with urlLinkName: String) {
        isFetchingData = true
        serviceState = .fetchingDetailsData
        let urlString: String = "\(tvShowsSourceURL)show-details?q=\(urlLinkName)"
        fetchDetailsData(with: urlString)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func fetchDataForHomeTableViewRows() {
        switch fetchHomeQueueState {
            case .fetchingRowsData:
                serviceState = .fetchingTableViewRows
            case .rowsFetched:
                serviceState = .tableViewRowsFetched
            default: return
        }
        let stringNumber = String(tvShowsPageIndex)
        let urlString: String = "\(tvShowsSourceURL)most-popular?page=\(stringNumber)"
        fetchHomeData(with: urlString)
    }
    
    private func prepareHomeTableViewData(with rowData: HomeViewDataModel) {
        switch self.serviceState {
            case .fetchingTableViewRows:
                self.tvShowsPageIndex += 1
                self.homeTableViewRowsData.append(rowData)
                if self.homeTableViewRowsData.count > 1 { self.fetchHomeQueueState = .rowsFetched }
                self.fetchDataForHomeTableViewRows()
                
            case .tableViewRowsFetched:
                self.tvShowsPageIndex += 1
                self.homeTableViewRowsData.append(rowData)
                self.delegate?.didGetHomeTableData(with: self.homeTableViewRowsData)
                self.homeTableViewRowsData.removeAll()
                
            case .fetchingFavoritesCarrouselData:
                self.delegate?.didGetSinglePageData(with: rowData.tvShow)
                self.homeTableViewRowsData.removeAll()
                
            case .fetchingSearchData:
                self.delegate?.didGetSearchData(with: rowData)
                self.tvShowsPageIndex = 1
                self.homeTableViewRowsData.removeAll()
                
            default: return
        }
    }
    
    // MARK: - FETCH METHODS
    
    private func fetchHomeData(with urlString: String) {
        urlSession.execute(with: urlString) { (result: Result<HomeViewDataModel, Error>) in
            switch result {
                case .success(let tableViewRowData):
                    self.isFetchingData = false
                    self.prepareHomeTableViewData(with: tableViewRowData)
                    
                case .failure(let error):
                    self.isFetchingData = false
                    self.tvShowsPageIndex += 1
                    self.delegate?.didFailWithError(error)
            }
        }
    }
    
    private func fetchDetailsData(with urlString: String) {
        urlSession.execute(with: urlString) { (result: Result<DetailsViewDataModel, Error>) in
            switch result {
                case .success(let detailsViewEntity):
                    self.isFetchingData = false
                    self.delegate?.didGetDetailsData(with: detailsViewEntity)
                case .failure(let error):
                    self.delegate?.didFailWithError(error)
            }
        }
    }
}

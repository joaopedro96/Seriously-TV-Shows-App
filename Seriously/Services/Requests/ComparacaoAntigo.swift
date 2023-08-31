////  HomeViewModel.swift
////  Seriously
////
////  Created by Joao Pedro da Mata Gonçalves Ribeiro on 03/11/21.
////
//
//import UIKit
//
//protocol RequestServiceProtocolAntigo: AnyObject {
//    func didGetSinglePageData(with tvShowList: [TvShowPlanData])
//    func didGetHomeTableData(with tableViewData: [HomeViewDataModel])
//    func didGetSearchData(with tvShowSearchedData: HomeViewDataModel)
//    func didGetDetailsData(with data: DetailsViewDataModel)
//    func didFailWithError(_ error: Error)
//}
//
//extension RequestServiceProtocolAntigo {
//    func didGetSinglePageData(with tvShowList: [TvShowPlanData]) { }
//    func didGetHomeTableData(with tableViewData: [HomeViewDataModel]) { }
//    func didGetSearchData(with text: HomeViewDataModel) { }
//    func didGetDetailsData(with data: DetailsViewDataModel) { }
//}
//
//class RequestServiceManagerAntigo {
//    
//    // MARK: - PROPERTIES
//    
//    static public let sharedInstance = RequestServiceManager()
//    public weak var delegate: RequestServiceProtocol?
//    private var isPaginating: Bool = false
//    private let tvShowsSourceURL = "https://www.episodate.com/api/"
//    private var loopAPICallerIndex = 1
//    private var tvShowsPageIndex = 1
//    private var didGetSearchedData = false
//    private var didFinishedApiLoopState = false
//    private var didGetSinglePageData = false
//    private var didResetData = false
//    private var didGetDetailsData = false
//    private var tvShowsEntityRow: [HomeViewDataModel] = []
//    
//    private var httpClient = HTTPClient()
//    
////    private init() {}
//    
//    // MARK: - PUBLIC METHODS
//    
//    public func fetchDataForHome() {
//        if !isPaginating {
//            loopAPICallerIndex = 1
//            isPaginating = true
//            fetchDataForHomePage()
//        }
//    }
//    
//    public func resetData() {
//        if !isPaginating {
//            loopAPICallerIndex = 1
//            tvShowsPageIndex = 1
//            didResetData = true
//            isPaginating = true
//            fetchDataForHomePage()
//        }
//    }
//    
//    public func fetchData(forPage: Int) {
//        didGetSinglePageData = true
//        loopAPICallerIndex = 4
//        isPaginating = true
//        let stringNumber = String(forPage)
//        let urlString: String = "\(tvShowsSourceURL)most-popular?page=\(stringNumber)"
//        print(urlString)
//        fetchHomeDatas(with: urlString)
////        performRequest(with: urlString)
//    }
//    
//    public func fetchSearchData(with Searchedtext: String, and page: Int = 1) {
//        didGetSearchedData = true
//        didGetSinglePageData = false
//        loopAPICallerIndex = 4
//        isPaginating = true
//        let urlString: String = "\(tvShowsSourceURL)search?q=\(Searchedtext)&page=\(page)"
//        print(urlString)
//        fetchHomeDatas(with: urlString)
////        performRequest(with: urlString)
//    }
//    
//    public func fetchDetailsData(with urlLinkName: String) {
//        isPaginating = true
//        didGetDetailsData = true
//        let urlString: String = "\(tvShowsSourceURL)show-details?q=\(urlLinkName)"
//        print(urlString)
//        fetchDetailsDatas(with: urlString)
////        performRequest(with: urlString)
//    }
//    
//    // MARK: - PRIVATE METHODS
//    
//    private func fetchDataForHomePage() {
//        if loopAPICallerIndex > 3 {
//            loopAPICallerIndex = 1
//            didFinishedApiLoopState = true
//            didGetSinglePageData = false
//            return
//        }
//        didFinishedApiLoopState = false
//        let stringNumber = String(tvShowsPageIndex)
//        let urlString: String = "\(tvShowsSourceURL)most-popular?page=\(stringNumber)"
//        print(urlString)
//        fetchHomeDatas(with: urlString)
////        performRequest(with: urlString)
//    }
//    
//    // MARK: - URL SESSION
//    
//    private func fetchHomeDatas(with urlString: String) {
//        httpClient.execute(with: urlString) { (result: Result<HomeViewDataModel, Error>) in
//            switch result {
//            case .success(let homeViewEntity):
//                self.tvShowsEntityRow.append(homeViewEntity)
//                if self.loopAPICallerIndex <= 3 {
//                    self.loopAPICallerIndex += 1
//                    self.tvShowsPageIndex += 1
//                    self.fetchDataForHomePage()
//                }
//                
//                if self.didFinishedApiLoopState {
//                    self.didFinishedApiLoopState = false
//                    self.isPaginating = false
//                    self.delegate?.didGetHomeTableData(with: self.tvShowsEntityRow)
//                    self.tvShowsEntityRow.removeAll()
//                }
//                
//                if self.didGetSinglePageData {
//                    self.isPaginating = false
//                    self.delegate?.didGetSinglePageData(with: homeViewEntity.tvShow)
//                    self.tvShowsEntityRow.removeAll()
//                }
//                
//                if self.didGetSearchedData {
//                    self.isPaginating = false
//                    self.didGetSearchedData = false
//                    self.delegate?.didGetSearchData(with: homeViewEntity)
//                    self.tvShowsPageIndex = 1
//                    self.tvShowsEntityRow.removeAll()
//                }
//                
//            case .failure(let error):
//                if self.loopAPICallerIndex <= 3 {
//                    self.loopAPICallerIndex += 1
//                    self.tvShowsPageIndex += 1
//                    self.fetchDataForHomePage()
//                } else {
//                    self.isPaginating = false
//                    self.didFinishedApiLoopState = false
//                    self.didGetSinglePageData = false
//                    self.didGetSearchedData = false
//                    self.didGetDetailsData = false
//                }
//                self.delegate?.didFailWithError(error)
//            }
//        }
//    }
//    
//    private func fetchDetailsDatas(with urlString: String) {
//        httpClient.execute(with: urlString) { (result: Result<DetailsViewDataModel, Error>) in
//            switch result {
//            case .success(let detailsViewEntity):
//                self.isPaginating = false
//                self.didGetDetailsData = false
//                self.delegate?.didGetDetailsData(with: detailsViewEntity)
//            case .failure(let error):
//                self.delegate?.didFailWithError(error)
//            }
//        }
//    }
//    
//    private func performRequest(with urlString: String) {
//        //1. Create URL
//        if let url = URL(string: urlString) {
//            //2. Create URL Session
//            let session = URLSession(configuration: .default)
//            //3. Give the session a task
//            let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
//            //4. Start the task
//            task.resume()
//        }
//    }
//    
//    private func handle(data: Data?, response: URLResponse?, error: Error?) {
//        if error != nil {
//            isPaginating = false
//            delegate?.didFailWithError(error!)
//            return
//        }
//        if let safeData = data {
//            
//            if !didGetDetailsData {
//                if let parsedEntity = parseJSON(safeData) {
//                    if didFinishedApiLoopState {
//                        didFinishedApiLoopState = false
//                        isPaginating = false
//                        delegate?.didGetHomeTableData(with: tvShowsEntityRow)
//                        tvShowsEntityRow.removeAll()
//                    }
//                    if didGetSinglePageData {
//                        isPaginating = false
//                        delegate?.didGetSinglePageData(with: parsedEntity.tvShow)
//                        tvShowsEntityRow.removeAll()
//                    }
//                    if didGetSearchedData {
//                        isPaginating = false
//                        didGetSearchedData = false
//                        delegate?.didGetSearchData(with: parsedEntity)
//                        tvShowsPageIndex = 1
//                        tvShowsEntityRow.removeAll()
//                    }
//                }
//            } else {
//                if let detailsData = parseDetailsJSON(safeData) {
//                    isPaginating = false
//                    didGetDetailsData = false
//                    delegate?.didGetDetailsData(with: detailsData)
//                }
//            }
//        }
//    }
//    
//    private func parseJSON(_ entityData: Data) -> HomeViewDataModel? {
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode(HomeViewDataModel.self, from: entityData)
//            let entityData = decodedData
//            tvShowsEntityRow.append(entityData)
//            if loopAPICallerIndex <= 3 {
//                loopAPICallerIndex += 1
//                tvShowsPageIndex += 1
//                fetchDataForHomePage()
//            }
//            return entityData
//            
//        } catch {
//            if loopAPICallerIndex <= 3 {
//                loopAPICallerIndex += 1
//                tvShowsPageIndex += 1
//                fetchDataForHomePage()
//            } else {
//                isPaginating = false
//                didFinishedApiLoopState = false
//                didGetSinglePageData = false
//                didGetSearchedData = false
//                didGetDetailsData = false
//            }
//            delegate?.didFailWithError(error)
//            return nil
//        }
//    }
//    
//    private func parseDetailsJSON(_ entityData: Data) -> DetailsViewDataModel? {
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode(DetailsViewDataModel.self, from: entityData)
//            return decodedData
//            
//        } catch {
//            delegate?.didFailWithError(error)
//            return nil
//        }
//    }
//}
//
//// MARK: - EXTENSIONS
//
//extension RequestServiceManagerAntigo: UrlSessionProtocol {
//    func didPerformUrlSession<T>(with result: UrlStatus<T>.URLSessionStatus) {
//        switch result {
//        case .SUCCESS(let data):
//            
//            if let detailsViewEntity = data as? DetailsViewDataModel {
//                isPaginating = false
//                didGetDetailsData = false
//                delegate?.didGetDetailsData(with: detailsViewEntity)
//            }
//            
//            
//            if let homeViewEntity = data as? HomeViewDataModel {
//                tvShowsEntityRow.append(homeViewEntity)
//                if loopAPICallerIndex <= 3 {
//                    loopAPICallerIndex += 1
//                    tvShowsPageIndex += 1
//                    fetchDataForHomePage()
//                }
//            }
//            
//            
//            
//        case .FAILURE(let type, let error):
//                
//            if type is DetailsViewDataModel {
//                delegate?.didFailWithError(error)
//            }
//            
//            
//            if type is HomeViewDataModel {
//                if loopAPICallerIndex <= 3 {
//                    loopAPICallerIndex += 1
//                    tvShowsPageIndex += 1
//                    fetchDataForHomePage()
//                } else {
//                    isPaginating = false
//                    didFinishedApiLoopState = false
//                    didGetSinglePageData = false
//                    didGetSearchedData = false
//                    didGetDetailsData = false
//                }
//                delegate?.didFailWithError(error)
//            }
//        }
//    }
//}

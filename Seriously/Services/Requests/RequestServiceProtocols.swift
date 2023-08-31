//
//  RequestServiceProtocols.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 01/03/22.
//

import Foundation

protocol RequestServiceProtocol: AnyObject {
    func didGetSinglePageData(with tvShowList: [TvShowPlanData])
    func didGetHomeTableData(with tableViewData: [HomeViewDataModel])
    func didGetSearchData(with tvShowSearchedData: HomeViewDataModel)
    func didGetDetailsData(with data: DetailsViewDataModel)
    func didFailWithError(_ error: Error)
}

extension RequestServiceProtocol {
    func didGetSinglePageData(with tvShowList: [TvShowPlanData]) { }
    func didGetHomeTableData(with tableViewData: [HomeViewDataModel]) { }
    func didGetSearchData(with text: HomeViewDataModel) { }
    func didGetDetailsData(with data: DetailsViewDataModel) { }
}

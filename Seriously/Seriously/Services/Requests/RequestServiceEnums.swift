//
//  RequestServiceEnums.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 01/03/22.
//

import Foundation

enum RequestServiceState {
    case emptyState
    case fetchingTableViewRows
    case tableViewRowsFetched
    case fetchingFavoritesCarrouselData
    case fetchingSearchData
    case fetchingDetailsData
}

enum RequestServiceHomeFetchQueueState {
    case fetchingRowsData
    case rowsFetched
    case emptyQueue
}

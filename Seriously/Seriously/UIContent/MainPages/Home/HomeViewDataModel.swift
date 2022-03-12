//
//  HomeViewDataModel.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 03/11/21.
//

public struct HomeViewDataModel: Codable {
    public let totalTvSeries: String
    public let currentPage: Int
    public let totalPages: Int
    public let tvShow: [TvShowPlanData]
    
    enum CodingKeys: String, CodingKey {
        case totalTvSeries = "total"
        case currentPage = "page"
        case totalPages = "pages"
        case tvShow = "tv_shows"
    }
}

public struct TvShowPlanData: Codable {
    public let id: Int
    public let name: String
    public let searchLink: String
    public let startDate: String?
    public let endDate: String?
    public let country: String
    public let network: String?
    public let status: String
    public let image: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case searchLink = "permalink"
        case startDate = "start_date"
        case endDate = "end_date"
        case country = "country"
        case network = "network"
        case status = "status"
        case image = "image_thumbnail_path"
    }
}

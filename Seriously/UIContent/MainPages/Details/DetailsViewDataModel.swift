//
//  DetailsViewDataModel.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 18/11/21.
//

import Foundation

public struct DetailsViewDataModel: Codable {
    public let tvShowDetails: TvShowDetailsPlanData
    
    enum CodingKeys: String, CodingKey {
        case tvShowDetails = "tvShow"
    }
}

public struct TvShowDetailsPlanData: Codable {
    public let title: String
    public let plot: String
    public let id: Int
    public let country: String
    public let status: String
    public let network: String
    public let poster: String
    public let rate: String
    public let genre: [String]
    public let pictures: [String]
    public let episodes: [TvShowDetailsEpisodesData]
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case plot = "description"
        case id = "id"
        case country = "country"
        case status = "status"
        case network = "network"
        case poster = "image_path"
        case rate = "rating"
        case genre = "genres"
        case pictures = "pictures"
        case episodes = "episodes"
    }
}

public struct TvShowDetailsEpisodesData: Codable {
    public let season: Int
    public let number: Int
    public let title: String
    public let airDate: String
    
    enum CodingKeys: String, CodingKey {
        case season = "season"
        case number = "episode"
        case title = "name"
        case airDate = "air_date"
    }
}

//
//  DetailsEpisodeView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 31/05/22.
//

import UIKit

struct TableViewSectionModel {
    let season: Int
    let episodesData: [TableViewCellModel]
    var isOpened: Bool
    
    init(season: Int, episodesData: [TableViewCellModel], isOpened: Bool = false) {
        self.season = season
        self.episodesData = episodesData
        self.isOpened = isOpened
    }
    
    struct TableViewCellModel {
        let episodeTitle: String
        let episodeNumber: Int
    }
}

class DetailsEpisodeView: UIView {
    
    // MARK: - CONSTANTS
    
    private struct Constants {
        static let titleLabelText = "Episodes"
        static let seasonCellTitle = "SeasonCellTitle"
        static let episodeCellTitle = "EpisodeCellTitle"
    }
    
    private enum Metrics {
        static let smallMargin: CGFloat = 12
        static let standardMargin: CGFloat = 24
        static let hugeMargin: CGFloat = 48
        static let tableViewPadding: CGFloat = 12
        static let fontSize: CGFloat = 18
        static let rowEstimatedHeight: CGFloat = 120
    }
    
    // MARK: - PROPERTIES
    
    private var episodeDataList: [TableViewSectionModel] = []
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.text = Constants.titleLabelText
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSize, weight: .regular)
        setupComponent.textColor = .white
        return setupComponent
    }()
    
    private lazy var tableView: DynamicHeightTableView = {
        let setupComponent = DynamicHeightTableView()
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.register(DetailsTableViewSeasonCell.self, forCellReuseIdentifier: Constants.seasonCellTitle)
        setupComponent.register(DetailsTableViewEpisodeCell.self, forCellReuseIdentifier: Constants.episodeCellTitle)
        setupComponent.estimatedRowHeight = Metrics.rowEstimatedHeight
        setupComponent.rowHeight = UITableView.automaticDimension
        setupComponent.showsVerticalScrollIndicator = false
        setupComponent.isScrollEnabled = false
        setupComponent.separatorColor = .clear
        setupComponent.backgroundColor = .clear
        setupComponent.dataSource = self
        setupComponent.delegate = self
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updateEpisodesView(with episodeList: [TvShowDetailsEpisodesData]) {
        episodeDataList = makeSectionModelData(with: episodeList)
        setupView()
    }

    // MARK: - PRIVATE METHODS
    
    private func makeSectionModelData(with episodeList: [TvShowDetailsEpisodesData]) -> [TableViewSectionModel] {
        var episodeDataList: [TableViewSectionModel] = []
        guard let totalSeasons = episodeList.max(by: { $1.season > $0.season })?.season else { return episodeDataList }
        
        for seasonIndex in 1...totalSeasons {
            var cellModel: [TableViewSectionModel.TableViewCellModel] = []
            episodeList.forEach {
                if $0.season == seasonIndex {
                    let cellData = TableViewSectionModel.TableViewCellModel(episodeTitle: $0.title, episodeNumber: $0.number)
                    cellModel.append(cellData)
                }
            }
            let sectionModel = TableViewSectionModel(season: seasonIndex, episodesData: cellModel)
            episodeDataList.append(sectionModel)
        }
        return episodeDataList
    }
    
    private func removeLastCellSeparatorLine(from cell: DetailsTableViewEpisodeCell, and indexPath: IndexPath) {
        if indexPath.row == episodeDataList[indexPath.section].episodesData.count {
            cell.hideSeparatorLine()
        }
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(tableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.standardMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.standardMargin),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.smallMargin),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.standardMargin),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.standardMargin),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.hugeMargin)
        ])
    }
}

// MARK: - EXTENSIONS

extension DetailsEpisodeView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodeDataList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableViewSection = episodeDataList[section]
        if tableViewSection.isOpened {
            return tableViewSection.episodesData.count + 1
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let seasonCell = tableView.dequeueReusableCell(withIdentifier: Constants.seasonCellTitle, for: indexPath)
            guard let seasonCell = seasonCell as? DetailsTableViewSeasonCell else { return UITableViewCell() }
            seasonCell.updateCell(with: episodeDataList[indexPath.section])
            return seasonCell
        } else {
            let episodeCell = tableView.dequeueReusableCell(withIdentifier: Constants.episodeCellTitle, for: indexPath)
            guard let episodeCell = episodeCell as? DetailsTableViewEpisodeCell else { return UITableViewCell() }
            episodeCell.updateCell(with: episodeDataList[indexPath.section].episodesData[indexPath.row - 1])
            removeLastCellSeparatorLine(from: episodeCell, and: indexPath)
            return episodeCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        episodeDataList[indexPath.section].isOpened = !episodeDataList[indexPath.section].isOpened
        tableView.reloadSections([indexPath.section], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let verticalPadding: CGFloat = Metrics.tableViewPadding
            let maskLayer = CALayer()
            maskLayer.cornerRadius = 8
            maskLayer.backgroundColor = UIColor.indigo600.cgColor
            maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
            cell.layer.mask = maskLayer
        }
    }
}

extension DetailsEpisodeView: UITableViewDelegate { }

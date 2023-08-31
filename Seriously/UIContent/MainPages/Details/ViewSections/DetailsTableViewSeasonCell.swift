//
//  DetailsTableViewSectionHeader.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 02/06/22.
//

import UIKit

class DetailsTableViewSeasonCell: UITableViewCell {
    
    // MARK: - CONSTANTS
    
    private enum Metrics {
        static let standardMargin: CGFloat = 12
        static let mediumfontSize: CGFloat = 14
        static let standardFontSize: CGFloat = 18
        static let chevronSize: CGSize = CGSize(width: 18, height: 18)
    }
    
    // MARK: - INITIALIZER
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var seasonLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.standardFontSize, weight: .bold)
        setupComponent.textColor = .sky300
        setupComponent.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return setupComponent
    }()
    
    private lazy var episodeLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.mediumfontSize, weight: .regular)
        setupComponent.textColor = .gray300
        setupComponent.textAlignment = .right
        return setupComponent
    }()
    
    private lazy var chevronIcon: UIImageView = {
        let setupComponent = UIImageView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.image = .systemChevronDownIcon.withRenderingMode(.alwaysOriginal).withTintColor(.gray300)
        setupComponent.contentMode = .scaleToFill
        return setupComponent
    }()

    // MARK: - PUBLIC METHODS

    public func updateCell(with sectionModel: TableViewSectionModel) {
        seasonLabel.text = "Season \(sectionModel.season)"
        episodeLabel.text = "\(sectionModel.episodesData.count) Episodes"
        customizeCell(with: sectionModel.isOpened)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func customizeCell(with cellState: Bool) {
        backgroundColor = cellState ? .sky100 : .indigo600
        seasonLabel.textColor = cellState ? .white : .sky400
        episodeLabel.textColor = cellState ? .white : .gray300
        if cellState {
            chevronIcon.image = .systemChevronUpIcon.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        } else {
            chevronIcon.image = .systemChevronDownIcon.withRenderingMode(.alwaysOriginal).withTintColor(.gray300)
        }
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
        customizeView()
    }
    
    private func buildViewHierarchy() {
        contentView.addSubview(seasonLabel)
        contentView.addSubview(episodeLabel)
        contentView.addSubview(chevronIcon)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.standardMargin),
            seasonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.standardMargin),
            seasonLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.standardMargin),
            
            episodeLabel.leadingAnchor.constraint(equalTo: seasonLabel.trailingAnchor),
            episodeLabel.bottomAnchor.constraint(equalTo: seasonLabel.bottomAnchor),
            
            chevronIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronIcon.leadingAnchor.constraint(equalTo: episodeLabel.trailingAnchor, constant: Metrics.standardMargin),
            chevronIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.standardMargin),
            chevronIcon.heightAnchor.constraint(equalToConstant: Metrics.chevronSize.height),
            chevronIcon.widthAnchor.constraint(equalToConstant: Metrics.chevronSize.width)
        ])
    }
    
    private func customizeView() {
        selectionStyle = .none
    }
}


//
//  DetailsTableViewEpisodeCell.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 02/06/22.
//

import UIKit

class DetailsTableViewEpisodeCell: UITableViewCell {
    
    // MARK: - CONSTANTS
    
    private enum Metrics {
        static let shortMargin: CGFloat = 4
        static let smallMargin: CGFloat = 6
        static let standardMargin: CGFloat = 12
        static let fontSize: CGFloat = 14
        static let separatorLineHeight: CGFloat = 0.5
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

    private lazy var episodeLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSize, weight: .regular)
        setupComponent.textColor = .gray300
        setupComponent.adjustsFontSizeToFitWidth = true
        setupComponent.minimumScaleFactor = 0.6
        return setupComponent
    }()
    
    private lazy var separatorLine: UIView = {
        let setupComponent = UIView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.backgroundColor = .gray100
        return setupComponent
    }()

    // MARK: - PUBLIC METHODS

    public func updateCell(with cellModel: TableViewSectionModel.TableViewCellModel) {
        episodeLabel.text = "Episode \(cellModel.episodeNumber): \(cellModel.episodeTitle)"
    }
    
    public func hideSeparatorLine() {
        separatorLine.isHidden = true
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
        customizeView()
    }
    
    private func buildViewHierarchy() {
        contentView.addSubview(episodeLabel)
        contentView.addSubview(separatorLine)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            episodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.shortMargin),
            episodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.standardMargin),
            episodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.standardMargin),
            
            separatorLine.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor, constant: Metrics.smallMargin),
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.standardMargin),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.standardMargin),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: Metrics.separatorLineHeight)
        ])
    }
    
    private func customizeView() {
        selectionStyle = .none
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
}


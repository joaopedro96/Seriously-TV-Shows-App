//
//  DetailsDescriptionView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 19/11/21.
//

import UIKit

class DetailsDescriptionView: UIView {
    
    // MARK: - CONSTANTS
    
    private struct Constants {
        static let plotLabelText = "The Plot"
        static let seeMoreLabelText = "See more"
        static let networkText = "Network"
        static let genreText = "Genres"
        static let rateText = "Rating"
        static let countryText = "Country"
        static let statusText = "Status"
        static let seasonText = "Seasons"
        static let episodeText = "Episodes"
    }
    
    private enum Metrics {
        static let smallSpacing: CGFloat = 8
        static let minimumMargin: CGFloat = 2
        static let shortMargin: CGFloat = 12
        static let standardMargin: CGFloat = 24
        static let fontSizeMedium: CGFloat = 16
        static let fontSize: CGFloat = 18
        static let arrowButtonSize = CGSize(width: 30, height: 30)
    }
    
    // MARK: - PROPERTIES
    
    private var arrowButtonState = false
    
    // MARK: - INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var stackView: UIStackView = {
        let setupComponent = UIStackView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.axis = .vertical
        setupComponent.distribution = .fill
        setupComponent.spacing = Metrics.smallSpacing
        return setupComponent
    }()
    
    private lazy var plotTitleLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.text = Constants.plotLabelText
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSize, weight: .regular)
        setupComponent.textColor = .white
        return setupComponent
    }()
    
    private lazy var plotDescriptionLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 3
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeMedium, weight: .regular)
        setupComponent.textColor = .gray300
        return setupComponent
    }()
    
    private lazy var seeMorePlotLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.text = Constants.seeMoreLabelText
        setupComponent.isUserInteractionEnabled = true
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeMedium, weight: .bold)
        setupComponent.textColor = .sky100
        setupComponent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSeeMore)))
        return setupComponent
    }()
    
    private lazy var arrowButton: UIButton = {
        let setupComponent = UIButton(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.addTarget(self, action: #selector(didTapArrowButton), for: .touchUpInside)
        setupComponent.heightAnchor.constraint(equalToConstant: Metrics.arrowButtonSize.height).isActive = true
        setupComponent.widthAnchor.constraint(equalToConstant: Metrics.arrowButtonSize.width).isActive = true
        setupComponent.setImage(.uncheckedHeartIcon, for: .normal)
        setupComponent.setImage(.checkedHeartIcon, for: .selected)
        return setupComponent
    }()
    
    private lazy var networkLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeMedium, weight: .regular)
        setupComponent.textColor = .sky100
        return setupComponent
    }()
    
    private lazy var genresLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeMedium, weight: .regular)
        setupComponent.textColor = .sky100
        return setupComponent
    }()
    
    private lazy var ratingLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeMedium, weight: .regular)
        setupComponent.textColor = .sky100
        return setupComponent
    }()
    
    private lazy var countryLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeMedium, weight: .regular)
        setupComponent.textColor = .sky100
        return setupComponent
    }()
    
    private lazy var statusLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeMedium, weight: .regular)
        setupComponent.textColor = .sky100
        return setupComponent
    }()
    
    private lazy var seasonNumberLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeMedium, weight: .regular)
        setupComponent.textColor = .sky100
        return setupComponent
    }()
    
    private lazy var episodesNumberLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeMedium, weight: .regular)
        setupComponent.textColor = .sky100
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updateDescriptionView(with entity: TvShowDetailsPlanData) {
        plotDescriptionLabel.text = unmaskPlotText(for: entity.plot)
        networkLabel.attributedText = getText(with: Constants.networkText, and: entity.network)
        genresLabel.attributedText = getText(with: Constants.genreText, and: entity.genre[0])
        ratingLabel.attributedText = getText(with: Constants.rateText, and: entity.rate)
        countryLabel.attributedText = getText(with: Constants.countryText, and: entity.country)
        statusLabel.attributedText = getText(with: Constants.statusText, and: entity.status)
        seasonNumberLabel.attributedText = getText(with: Constants.seasonText, and: String(entity.episodes.last?.season ?? 1))
        episodesNumberLabel.attributedText = getText(with: Constants.episodeText, and: String(entity.episodes.count))
    }

    // MARK: - PRIVATE METHODS
    
    @objc private func didTapSeeMore() {
        seeMorePlotLabel.isHidden = true
        plotDescriptionLabel.numberOfLines = 0
        self.layoutIfNeeded()
    }
    
    @objc private func didTapArrowButton() {
        arrowButtonState = !arrowButtonState
        arrowButton.isSelected = arrowButtonState
    }
    
    private func getText(with title: String, and description: String) -> NSMutableAttributedString {
        let detailsAttributedString = NSMutableAttributedString(string: "\(title) : ")
        
        var descriptionAttributes = [NSAttributedString.Key: AnyObject]()
        descriptionAttributes[.foregroundColor] = UIColor.gray300
        descriptionAttributes[.font] = UIFont.roboto(ofSize: Metrics.fontSizeMedium, weight: .regular)
        
        let descriptionAttributesString = NSMutableAttributedString(string: " \(description)", attributes: descriptionAttributes)
        detailsAttributedString.append(descriptionAttributesString)
        return detailsAttributedString
    }
    
    private func unmaskPlotText(for text: String) -> String {
        let untaggedText = text.replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
            .replacingOccurrences(of: "<br>", with: "")
        return untaggedText
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(plotTitleLabel)
        addSubview(plotDescriptionLabel)
        addSubview(seeMorePlotLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(networkLabel)
        stackView.addArrangedSubview(genresLabel)
        stackView.addArrangedSubview(ratingLabel)
        stackView.addArrangedSubview(countryLabel)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(seasonNumberLabel)
        stackView.addArrangedSubview(episodesNumberLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            plotTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            plotTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.standardMargin),
            plotTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.standardMargin),
            
            plotDescriptionLabel.topAnchor.constraint(equalTo: plotTitleLabel.bottomAnchor, constant: Metrics.shortMargin),
            plotDescriptionLabel.leadingAnchor.constraint(equalTo: plotTitleLabel.leadingAnchor),
            plotDescriptionLabel.trailingAnchor.constraint(equalTo: plotTitleLabel.trailingAnchor),
            
            seeMorePlotLabel.topAnchor.constraint(equalTo: plotDescriptionLabel.bottomAnchor, constant: Metrics.minimumMargin),
            seeMorePlotLabel.leadingAnchor.constraint(equalTo: plotDescriptionLabel.leadingAnchor),
            seeMorePlotLabel.trailingAnchor.constraint(equalTo: plotDescriptionLabel.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: seeMorePlotLabel.bottomAnchor, constant: Metrics.shortMargin),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.standardMargin),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.standardMargin),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

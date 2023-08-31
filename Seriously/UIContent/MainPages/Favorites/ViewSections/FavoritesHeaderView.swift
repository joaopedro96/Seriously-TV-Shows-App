//
//  FavoritesHeaderView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 09/11/21.
//

import UIKit

protocol FavoritesHeaderViewProtocol: AnyObject {
    func didTapTvShowPoster(with searchLink: String)
    func loadImage(from urlString: String) -> UIImage?
}

class FavoritesHeaderView: UIView {
    
    // MARK: - CONSTANTS
    
    private struct Constants {
        static let recommendedLabelText = "Recommended for you"
        static let favoritesLabelText = "My Favorites"
    }
    
    private enum Metrics {
        static let tinyMargin: CGFloat = 4
        static let smallMargin: CGFloat = 8
        static let shortMargin: CGFloat = 12
        static let standardMargin: CGFloat = 24
        static let bigMargin: CGFloat = 32
        static let fontSizeSmall: CGFloat = 14
        static let fontSizeMedium: CGFloat = 16
        static let carouselCellSize: CGRect = CGRect(x: 0, y: 0, width: 100, height: 150)
        static let carouselMinScale: CGFloat = 0.5
        static let carouselMaxScale: CGFloat = 1.6
        static let carouselScaleMultiplier: CGFloat = 0.4
        static let carouselOffset: CGFloat = 2
        static let carouselWidth: CGFloat = 80
        static let maxLabelLayoutWidth: CGFloat = 400
    }
    
    // MARK: - PROPERTIES
    
    weak var delegate: FavoritesHeaderViewProtocol?
    private var buttonState: Bool = false
    
    // MARK: - INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var searchBarView: SearchBar = {
        let setupComponent = SearchBar(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        return setupComponent
    }()
    
    private lazy var carouselView: CarouselView<TvShowPlanData> = {
        let carouselLayout = CarouselLayoutModel(cellSize: Metrics.carouselCellSize,
                                            minScale: Metrics.carouselMinScale,
                                            maxScale: Metrics.carouselMaxScale,
                                            scaleMultiplier: Metrics.carouselScaleMultiplier,
                                            offset: Metrics.carouselOffset,
                                            width: Metrics.carouselWidth)
        let setupComponent = CarouselView<TvShowPlanData>(carouselLayout: carouselLayout)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.isUserInteractionEnabled = true
        setupComponent.delegate = self
        return setupComponent
    }()
    
    private lazy var recommendedSeriesLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeSmall, weight: .regular)
        setupComponent.textColor = .gray300
        setupComponent.text = Constants.recommendedLabelText
        setupComponent.numberOfLines = 1
        setupComponent.textAlignment = .center
        return setupComponent
    }()
    
    private lazy var titleLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeMedium, weight: .bold)
        setupComponent.textColor = .white
        setupComponent.numberOfLines = 1
        setupComponent.textAlignment = .center
        setupComponent.preferredMaxLayoutWidth = Metrics.maxLabelLayoutWidth
        return setupComponent
    }()
    
    private lazy var myFavoritesLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeMedium, weight: .regular)
        setupComponent.textColor = .white
        setupComponent.text = Constants.favoritesLabelText
        setupComponent.numberOfLines = 1
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updateCarouselItems(with carouselItemList: [TvShowPlanData]) {
        carouselView.updateCarouselItems(with: carouselItemList)
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
        customizeView()
    }
    
    private func buildViewHierarchy() {
        addSubview(searchBarView)
        addSubview(recommendedSeriesLabel)
        addSubview(carouselView)
        addSubview(titleLabel)
        addSubview(myFavoritesLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            recommendedSeriesLabel.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: Metrics.tinyMargin),
            recommendedSeriesLabel.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor),
            recommendedSeriesLabel.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor),
            
            carouselView.topAnchor.constraint(equalTo: recommendedSeriesLabel.bottomAnchor, constant: Metrics.smallMargin),
            carouselView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: carouselView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: carouselView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: carouselView.trailingAnchor),
            
            myFavoritesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.bigMargin),
            myFavoritesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.standardMargin),
            myFavoritesLabel.trailingAnchor.constraint(equalTo: carouselView.trailingAnchor),
            myFavoritesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.shortMargin)
        ])
    }
    
    private func customizeView() {
        backgroundColor = .indigo500
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.endEditing(_:))))
    }
}

extension FavoritesHeaderView: ContainerCarouselViewProtocol {
    func setupCarouselCellView<T>(with cellForRowData: T?) -> UIView {
        let carouselCell = FavoritesCarouselCellView()
        carouselCell.posterView.image = nil
        carouselCell.isUserInteractionEnabled = true
        guard  let carouselItems = cellForRowData as? TvShowPlanData else { return carouselCell }
        DispatchQueue.global().async {
            guard let loadedImage = self.delegate?.loadImage(from: carouselItems.image) else { return }
            DispatchQueue.main.async {
                carouselCell.posterView.image = loadedImage
            }
        }
        return carouselCell
    }

    func didTapCarouselItem<T>(with data: T) {
        guard  let data = data as? TvShowPlanData else { return }
        delegate?.didTapTvShowPoster(with: data.searchLink)
    }
    
    func currentDisplayedCarouselItem<T>(with selectedItem: T) {
        guard  let selectedItem = selectedItem as? TvShowPlanData else { return }
        titleLabel.text = selectedItem.name
    }
}

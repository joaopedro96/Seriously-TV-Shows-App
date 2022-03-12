//
//  FavoritesView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 30/10/21.
//

import UIKit

class FavoritesView: UIView {
    
    // MARK: - CONSTANTS
    
    private enum Metrics {
        static let standardMargin: CGFloat = 24
    }
    
    // MARK: - PROPERTIES
    
    weak var delegate: FavoritesViewProtocol?
    
    // MARK: - UI
    
    private lazy var headerView: FavoritesHeaderView = {
        let setupComponent = FavoritesHeaderView()
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.delegate = self
        return setupComponent
    }()
    
    private lazy var favoritesTableView: FavoritesTableView = {
        let setupComponent = FavoritesTableView()
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.delegate = self
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updateFavoritesView(with favoriteData: FavoritesViewDataModel) {
        favoritesTableView.updateFavoritesTableView(with: favoriteData)
    }
    
    public func updateFavoritesView(with carouselItems: [TvShowPlanData]) {
        headerView.updateCarouselItems(with: carouselItems)
    }
    
    public func startView() {
        setupView()
        getCarouselItems()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func getCarouselItems() {
        delegate?.getCarouselItems()
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
        customizeView()
    }
    
    private func buildViewHierarchy() {
        self.addSubview(headerView)
        self.addSubview(favoritesTableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            favoritesTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            favoritesTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.standardMargin),
            favoritesTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.standardMargin),
            favoritesTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func customizeView() {
        self.backgroundColor = .indigo500
    }
}

extension FavoritesView: FavoritesHeaderViewProtocol {
    func loadImage(from urlString: String) -> UIImage? {
        delegate?.loadImage(from: urlString)
    }
    
    func didTapTvShowPoster(with searchLink: String) {
        delegate?.didTapTvShowPoster(with: searchLink)
    }
}

extension FavoritesView: FavoritesTableViewProtocol {
    func didTapCell(with id: String) {
        delegate?.didTapTvShowPoster(with: id)
    }
}

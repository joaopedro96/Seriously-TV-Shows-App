//
//  HomeView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 30/10/21.
//

import UIKit

class HomeView: UIView {
        
    // MARK: - CONSTANTS
    
    private enum Metrics {
        static let searchedPage: Int = 1
    }
    
    // MARK: - PROPERTIES
    
    weak var delegate: HomeViewProtocol?
    
    // MARK: - INITIALIZERS
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var containerStackView: UIStackView = {
        let setupComponent = UIStackView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.axis = .vertical
        setupComponent.distribution = .fill
        return setupComponent
    }()
    
    private lazy var searchBarView: SearchBar = {
        let setupComponent = SearchBar()
        setupComponent.delegate = self
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        return setupComponent
    }()
    
    private lazy var mainTableView: HomeMainTableView = {
        let setupComponent = HomeMainTableView()
        setupComponent.delegate = self
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updateHomeView(with tvShowSearchedData: HomeViewDataModel) {
        mainTableView.updateTableView(with: tvShowSearchedData)
    }
    
    public func updateHomeView(with tableViewData: [HomeViewDataModel]) {
        mainTableView.updateTableView(with: tableViewData)
    }
    
    // MARK: - PRIVATE METHODS
    
    @objc private func didTapOutsideTextField() {
        searchBarView.closeKeyboard()
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
        customizeView()
    }
    
    private func buildViewHierarchy() {
        self.addSubview(containerStackView)
        containerStackView.addArrangedSubview(searchBarView)
        containerStackView.addArrangedSubview(mainTableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }
    
    private func customizeView() {
        backgroundColor = .indigo500
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOutsideTextField)))
    }
}

// MARK: - EXTENSIONS

extension HomeView: SearchBarProtocol {
    func didMakeSearch(for text: String) {
        mainTableView.prepareTableView(for: text)
        delegate?.didMakeSearch(for: text, and: Metrics.searchedPage)
    }
    
    func didTapClear() {
        mainTableView.resetTableView()
    }
}

extension HomeView: HomeMainTableViewProtocol {
    func updateCellPosterView(with urlImage: String) -> UIImage? {
        guard let loadedImage = delegate?.updateCellPosterView(with: urlImage) else { return nil }
        return loadedImage
    }
    
    func resetHomeTableView() {
        delegate?.resetHomeTableView()
    }
    
    func updateHomeTableView() {
        delegate?.updateHomeTableView()
    }
    
    func loadMoreSearchedItems(with tvShowTitle: String, and page: Int) {
        delegate?.didMakeSearch(for: tvShowTitle, and: page)
    }
    
    func didTapPoster(with title: String) {
        delegate?.didTapTvShowPoster(with: title)
    }

    func goToHomeView(with favoriteData: FavoritesViewDataModel) {
        delegate?.goToHomeViewController(with: favoriteData)
    }
}

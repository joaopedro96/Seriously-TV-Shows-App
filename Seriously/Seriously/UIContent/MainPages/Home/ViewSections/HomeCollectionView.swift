//
//  HomeCollectionView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 01/11/21.
//

import UIKit

protocol HomeCollectionViewProtocol: AnyObject {
    func goToTableView(with favoritesData: FavoritesViewDataModel)
    func didTapCellPoster(with title: String)
    func updateCellPosterView(with urlImage: String) -> UIImage?
}

class HomeCollectionView: UITableViewCell {
    
    // MARK: - CONSTANTS
    
    private struct Constants {
        static let reusableCellTitle = "CollectionCell"
    }
    
    private enum Metrics {
        static let collectionViewRelativeHeight: CGFloat = 0.7
        static let collectionViewRelativeWidth: CGFloat = 0.4
        static let margin: CGFloat = 16
        static let mediumSpacing: CGFloat = 12
    }
    
    // MARK: - PROPERTIES
    
    private var collectionRowData: HomeViewDataModel?
    weak var delegate: HomeCollectionViewProtocol?
    
    // MARK: - INITIALIZER
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seriesCollectionView.reloadData()
    }
    
    // MARK: - UI
    
    private lazy var seriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Metrics.mediumSpacing
        
        let setupComponent = UICollectionView(frame: .zero, collectionViewLayout: layout)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.register(HomeCollectionCellView.self, forCellWithReuseIdentifier: Constants.reusableCellTitle)
        setupComponent.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        setupComponent.backgroundColor = .clear
        setupComponent.showsHorizontalScrollIndicator = false
        setupComponent.delegate = self
        setupComponent.dataSource = self
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updateView(with rowData: HomeViewDataModel?) {
        collectionRowData = rowData
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
        customizeView()
    }
    
    private func buildViewHierarchy() {
        contentView.addSubview(seriesCollectionView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            seriesCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            seriesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.margin),
            seriesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.margin),
            seriesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func customizeView() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }
}

// MARK: - EXTENSIONS

extension HomeCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * Metrics.collectionViewRelativeWidth,
                      height: collectionView.frame.width * Metrics.collectionViewRelativeHeight)
    }
}

extension HomeCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionRowData?.tvShow.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reusableCellTitle, for: indexPath)
        guard let collectionCellView = cell as? HomeCollectionCellView else { return cell }
        guard let collectionRowData = collectionRowData else { return collectionCellView }
        collectionCellView.delegate = self
        collectionCellView.updateCollectionCell(with: collectionRowData.tvShow[indexPath.row])
        return collectionCellView
    }
}

extension HomeCollectionView: HomeCollectionCellViewProtocol {
    func updateCellPosterView(with urlImage: String) -> UIImage? {
        guard let loadedImage = delegate?.updateCellPosterView(with: urlImage) else { return nil }
        return loadedImage
    }
    
    func didTapCellPoster(with title: String) {
        delegate?.didTapCellPoster(with: title)
    }
    
    func goToCollectionView(with favoritesData: FavoritesViewDataModel) {
        delegate?.goToTableView(with: favoritesData)
    }
}

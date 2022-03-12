//
//  FavoritesTableView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 09/11/21.
//

import UIKit

protocol FavoritesTableViewProtocol: AnyObject {
    func didTapCell(with id: String)
}

class FavoritesTableView: UIView {
    
    // MARK: - CONSTANTS
    
    private struct Constants {
        static let reusableCellTitle = "FavoriteTableCell"
    }
    
    private enum Metrics {
        static let screenWidth = UIScreen.main.bounds.width
        static let tableViewRelativeCellHeight: CGFloat = 0.3
        static let maskLayerPadding: CGFloat = 12
        static let maskLayerCornerRadius: CGFloat = 12
    }
    
    // MARK: - PROPERTIES
    
    weak var delegate: FavoritesTableViewProtocol?
    private var favoriteList: [FavoritesViewDataModel] = []
    
    // MARK: - INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var favoritesTableView: UITableViewController = {
        let setupComponent = UITableViewController()
        setupComponent.tableView.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: Constants.reusableCellTitle)
        setupComponent.tableView.showsVerticalScrollIndicator = false
        setupComponent.tableView.allowsSelection = false
        setupComponent.tableView.separatorColor = .clear
        setupComponent.tableView.backgroundColor = .clear
        setupComponent.tableView.dataSource = self
        setupComponent.tableView.delegate = self
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updateFavoritesTableView(with favoriteData: FavoritesViewDataModel) {
        favoriteList.append(favoriteData)
        favoritesTableView.tableView.reloadData()
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(favoritesTableView.tableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            favoritesTableView.tableView.topAnchor.constraint(equalTo: topAnchor),
            favoritesTableView.tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            favoritesTableView.tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            favoritesTableView.tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - EXTENSIONS

extension FavoritesTableView: UITableViewDelegate { }

extension FavoritesTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = Metrics.maskLayerPadding
        let maskLayer = CALayer()
        maskLayer.cornerRadius = Metrics.maskLayerCornerRadius
        maskLayer.backgroundColor = UIColor.lightGray.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reusableCellTitle, for: indexPath)
        guard let favoriteCell = cell as? FavoritesTableViewCell else { return cell }
        favoriteCell.delegate = self
        favoriteCell.updateFavoritesCellView(with: favoriteList[indexPath.row])
        return favoriteCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metrics.screenWidth * Metrics.tableViewRelativeCellHeight
    }
}

extension FavoritesTableView: FavoritesTableViewCellProtocol {
    func didTapCell(with id: String) {
        delegate?.didTapCell(with: id)
    }
}

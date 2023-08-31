//
//  HomeMainTableView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 02/11/21.
//

import UIKit

protocol HomeMainTableViewProtocol: AnyObject {
    func goToHomeView(with favoriteData: FavoritesViewDataModel)
    func didTapPoster(with title: String)
    func loadMoreSearchedItems(with tvShowTitle: String, and page: Int)
    func updateCellPosterView(with urlImage: String) -> UIImage?
    func updateHomeTableView()
    func resetHomeTableView()
}

class HomeMainTableView: UIView {
    
    // MARK: - CONSTANTS
    
    private struct Constants {
        static let reusableCellTitle = "TableCell"
    }
    
    private enum Metrics {
        static let screenWidth = UIScreen.main.bounds.width
        static let spinnerFooter = CGRect(x: 0, y: 0, width: screenWidth, height: 100)
        static let scrollOffset: CGFloat = 100
        static let collectionViewRelativeHeight: CGFloat = 0.70
    }
    
    // MARK: - PROPERTIES
    
    weak var delegate: HomeMainTableViewProtocol?
    private var tableViewRowsData: [HomeViewDataModel] = []
    private var isSearchStateActive: Bool = false
    private var currentTextSearched: String = ""
    private var currentSearchedPage: Int = 1
    private var maxSearchedPage: Int?
    
    // MARK: - INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var mainTableViewController: UITableViewController = {
        let setupComponent = UITableViewController(style: .grouped)
        setupComponent.tableView.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.tableView.register(HomeCollectionView.self, forCellReuseIdentifier: Constants.reusableCellTitle)
        setupComponent.tableView.showsVerticalScrollIndicator = false
        setupComponent.tableView.allowsSelection = false
        setupComponent.tableView.separatorColor = .clear
        setupComponent.tableView.backgroundColor = .clear
        setupComponent.tableView.dataSource = self
        setupComponent.tableView.delegate = self
        setupComponent.tableView.tableFooterView = createSpinnerFooter()
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
        
    public func prepareTableView(for searchedText: String) {
        isSearchStateActive = true
        currentTextSearched = searchedText
        currentSearchedPage = 1
        tableViewRowsData.removeAll()
        DispatchQueue.main.async {
            self.mainTableViewController.tableView.tableHeaderView = nil
            self.mainTableViewController.tableView(self.mainTableViewController.tableView, viewForHeaderInSection: 1)
            self.mainTableViewController.tableView.reloadData()
        }
    }
    
    public func updateTableView(with searchedData: HomeViewDataModel) {
        tableViewRowsData.append(searchedData)
        maxSearchedPage = searchedData.totalPages
        currentSearchedPage += 1
        DispatchQueue.main.async {
            self.mainTableViewController.tableView.tableFooterView = nil
            self.mainTableViewController.tableView.reloadData()
        }
    }
    
    public func updateTableView(with tableViewData: [HomeViewDataModel]) {
        tableViewData.forEach { self.tableViewRowsData.append($0) }
        DispatchQueue.main.async {
            self.mainTableViewController.tableView.tableFooterView = nil
            self.mainTableViewController.tableView.reloadData()
        }
    }
    
    public func resetTableView() {
        isSearchStateActive = false
        currentSearchedPage = 1
        currentTextSearched = ""
        tableViewRowsData.removeAll()
        DispatchQueue.main.async {
            self.mainTableViewController.tableView.tableFooterView = self.createSpinnerFooter()
            self.mainTableViewController.tableView.reloadData()
        }
        delegate?.resetHomeTableView()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func fetchSeries() {
        if !isSearchStateActive {
            mainTableViewController.tableView.tableFooterView = createSpinnerFooter()
            delegate?.updateHomeTableView()
        } else {
            guard let maxPageIndex = maxSearchedPage else { return }
            if currentSearchedPage <= maxPageIndex {
                mainTableViewController.tableView.tableFooterView = createSpinnerFooter()
                delegate?.loadMoreSearchedItems(with: currentTextSearched, and: currentSearchedPage)
            }
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: Metrics.spinnerFooter)
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = .sky100
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(mainTableViewController.tableView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainTableViewController.tableView.topAnchor.constraint(equalTo: topAnchor),
            mainTableViewController.tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainTableViewController.tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainTableViewController.tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - EXTENSIONS

extension HomeMainTableView: UITableViewDelegate { }

extension HomeMainTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reusableCellTitle, for: indexPath)
//        guard let collectionCell = cell as? HomeCollectionView else { return cell }
        let collectionCell = HomeCollectionView()
        collectionCell.delegate = self
//        collectionCell.updateView(with: nil)
        collectionCell.updateView(with: self.tableViewRowsData[indexPath.row])
        return collectionCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !isSearchStateActive {
            let headerView = HomeMainTableHeaderView()
            headerView.delegate = self
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metrics.screenWidth * Metrics.collectionViewRelativeHeight
    }
}

extension HomeMainTableView: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let position = scrollView.contentOffset.y
        if position > (mainTableViewController.tableView.contentSize.height + Metrics.scrollOffset - scrollView.frame.size.height) {
            fetchSeries()
        }
    }
}

extension HomeMainTableView: HomeHeaderViewProtocol {
    func didTapHeaderBanner(with title: String) {
        delegate?.didTapPoster(with: title)
    }
}

extension HomeMainTableView: HomeCollectionViewProtocol {
    func updateCellPosterView(with urlImage: String) -> UIImage? {
        guard let loadedImage = delegate?.updateCellPosterView(with: urlImage) else { return nil }
        return loadedImage
    }
    
    func didTapCellPoster(with title: String) {
        delegate?.didTapPoster(with: title)
    }

    func goToTableView(with favoriteData: FavoritesViewDataModel) {
        delegate?.goToHomeView(with: favoriteData)
    }
}

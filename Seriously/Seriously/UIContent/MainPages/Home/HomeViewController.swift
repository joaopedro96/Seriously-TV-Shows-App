//
//  HomeViewController.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 30/10/21.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - PROPERTIES
    
    weak var delegate: HomeViewControllerProtocol?
    private let homeView: HomeView
    private let viewModel: HomeViewModel
    
    // MARK: - INITIALIZERS
    
    public init(homeView: HomeView = HomeView(), viewModel: HomeViewModel) {
        self.homeView = homeView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.delegate = self
        viewModel.delegate = self
        homeView.startHomeView()
        view = homeView
    }
}

// MARK: - EXTENSIONS

extension HomeViewController: HomeViewProtocol {
    func updateCellPosterView(with urlImage: String) -> UIImage? {
        guard let loadedImage = viewModel.getImage(from: urlImage) else { return nil }
        return loadedImage
    }
    
    func resetHomeTableView() {
        viewModel.resetData()
    }
    
    func updateHomeTableView() {
        viewModel.fetchHomeTableViewData()
    }
    
    func didMakeSearch(for text: String, and searchedPage: Int) {
        viewModel.fetchSearchedTvShowData(for: text, and: searchedPage)
    }
    
    func didTapTvShowPoster(with title: String) {
        viewModel.fetchDetailsPageData(for: title)
    }
    
    func goToHomeViewController(with favoriteData: FavoritesViewDataModel) {
        delegate?.goToFlowManager(with: favoriteData)
    }
}

extension HomeViewController: HomeViewModelProtocol {
    func didGetHomeTableData(with tableViewData: [HomeViewDataModel]) {
        homeView.updateHomeView(with: tableViewData)
    }
    
    func didGetDetailsData(with tvShowData: TvShowDetailsPlanData) {
        delegate?.goToDetailsPage(with: tvShowData)
    }
    
    func didGetSearchedData(with tvShowSearchedData: HomeViewDataModel) {
        homeView.updateHomeView(with: tvShowSearchedData)
    }
}

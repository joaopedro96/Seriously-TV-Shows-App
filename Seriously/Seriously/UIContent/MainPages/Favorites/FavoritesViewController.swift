//
//  FavoritesViewController.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 30/10/21.
//

import UIKit

class FavoritesViewController: BaseViewController {
    
    // MARK: - PROPERTIES
    
    weak var delegate: FavoritesViewControllerProtocol?
    private let favoritesView: FavoritesView
    private let viewModel: FavoritesViewModel
    
    // MARK: - INITIALIZERS
    
    public init(favoritesView: FavoritesView = FavoritesView(), viewModel: FavoritesViewModel) {
        self.favoritesView = favoritesView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesView.delegate = self
        viewModel.delegate = self
        favoritesView.startView()
        view = favoritesView
    }
    
    // MARK: - PUBLIC METHODS
    
    public func updateView(with favoriteData: FavoritesViewDataModel) {
        favoritesView.updateFavoritesView(with: favoriteData)
    }
}

// MARK: - EXTENSIONS

extension FavoritesViewController: FavoritesViewProtocol {
    func loadImage(from urlString: String) -> UIImage? {
        viewModel.getImage(from: urlString)
    }
    
    func didTapTvShowPoster(with searchLink: String) {
        viewModel.fetchDetailsPageData(for: searchLink)
    }
    
    func getCarouselItems(){
        viewModel.fetchCarouselItemsData()
    }
    
}

extension FavoritesViewController: FavoritesViewModelProtocol {
    func didGetCarouselItemsData(with tvShowItems: [TvShowPlanData]) {
        favoritesView.updateFavoritesView(with: tvShowItems)
    }
    
    func didGetDetailsData(with tvShowData: TvShowDetailsPlanData) {
        delegate?.goToDetailsPage(with: tvShowData)
    }
    
    func didGetSearchedData(with tvShowSearchedData: HomeViewDataModel) { }
}

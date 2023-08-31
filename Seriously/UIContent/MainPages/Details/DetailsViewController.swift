//
//  DetailsViewController.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 18/11/21.
//

import UIKit

class DetailsViewController: BaseViewController {
    
    weak var delegate: DetailsViewControllerProtocol?
    private let tvShowTitle: String
    private let detailsView: DetailsView
    private let viewModel: DetailsViewModel
    
    // MARK: - INITIALIZERS
    
    public init(datailsView: DetailsView = DetailsView(), tvShowTitle: String, viewModel: DetailsViewModel) {
        self.detailsView = datailsView
        self.tvShowTitle = tvShowTitle
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailsView
        viewModel.delegate = self
        detailsView.delegate = self
        viewModel.fetchDetailsPageData(for: tvShowTitle)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - EXTENSIONS

extension DetailsViewController: DetailsViewModelProtocol {
    func didGetDetailsData(with tvShowData: TvShowDetailsPlanData) {
        detailsView.updateDetailsView(with: tvShowData)
    }
}

extension DetailsViewController: DetailsViewProtocol {
    func goToDetailsViewController(with favoriteData: FavoritesViewDataModel) {
        delegate?.goToFlowManager(with: favoriteData)
    }
    
    func loadImage(from urlString: String) -> UIImage? {
        viewModel.getImage(from: urlString)
    }
}

//
//  DetailsViewController.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 18/11/21.
//

import UIKit

class DetailsViewController: BaseViewController {
    
    weak var delegate: DetailsViewControllerProtocol?
    private let datailsData: TvShowDetailsPlanData
    private let detailsView: DetailsView
    private let viewModel: DetailsViewModel
    
    // MARK: - INITIALIZERS
    
    public init(datailsView: DetailsView = DetailsView(), detailsData: TvShowDetailsPlanData, viewModel: DetailsViewModel) {
        self.detailsView = datailsView
        self.datailsData = detailsData
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.detailsView.delegate = self
        self.view = self.detailsView
        self.detailsView.updateDetailsView(with: datailsData)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - EXTENSIONS

extension DetailsViewController: DetailsViewModelProtocol { }

extension DetailsViewController: DetailsViewProtocol {
    func loadImage(from urlString: String) -> UIImage? {
        viewModel.getImage(from: urlString)
    }
}

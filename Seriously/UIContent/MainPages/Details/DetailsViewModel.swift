//
//  DetailsViewModel.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 29/11/21.
//

import UIKit

class DetailsViewModel {
    
    // MARK: - PROPERTIES
    
    private let requestServiceManager: RequestServiceManager
    weak var delegate: DetailsViewModelProtocol?

    // MARK: - INITIALIZERS
    
    init(requestSession: RequestServiceManager) {
        requestServiceManager = requestSession
        requestServiceManager.delegate = self
    }

    // MARK: - PUBLIC METHODS
    
    public func fetchDetailsPageData(for showTitle: String) {
        requestServiceManager.fetchDetailsPageData(with: showTitle) //fazer esse delegate retornar case .success and .fail
    }
    
    public func getImage(from urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: imageData)
    }
}

// MARK: - EXTENSIONS

extension DetailsViewModel: RequestServiceProtocol {
    func didFailWithError(_ error: Error) {
        print(error)
    }
        
    func didGetDetailsData(with tvShowData: DetailsViewDataModel) {
        delegate?.didGetDetailsData(with: tvShowData.tvShowDetails)
    }
}

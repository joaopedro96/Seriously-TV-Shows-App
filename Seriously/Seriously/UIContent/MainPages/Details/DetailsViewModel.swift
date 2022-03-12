//
//  DetailsViewModel.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 29/11/21.
//

import UIKit

class DetailsViewModel {
    
    // MARK: - PROPERTIES
    
    weak var delegate: DetailsViewModelProtocol?
    
    // MARK: - PUBLIC METHODS
    
    public func getImage(from urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: imageData)
    }
}

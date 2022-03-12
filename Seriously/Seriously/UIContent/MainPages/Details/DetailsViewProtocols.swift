//
//  DetailsViewProtocols.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 02/03/22.
//

import UIKit

protocol DetailsViewModelProtocol: AnyObject { }

protocol DetailsViewControllerProtocol: AnyObject { }

protocol DetailsViewProtocol: AnyObject {
    func loadImage(from urlString: String) -> UIImage?
}

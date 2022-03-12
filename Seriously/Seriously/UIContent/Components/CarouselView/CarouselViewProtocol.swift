//
//  CarouselViewProtocol.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 03/03/22.
//

import UIKit

protocol ContainerCarouselViewProtocol: AnyObject {
    func currentDisplayedCarouselItem<T>(with selectedItem: T)
    func didTapCarouselItem<T>(with data: T)
    func setupCarouselCellView<T>(with cellForRowData: T?) -> UIView
}

extension ContainerCarouselViewProtocol {
    func didTapCarouselItem<T>(with data: T) { }
    func currentDisplayedCarouselItem<T>(with selectedItem: T) { }
}

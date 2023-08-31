//
//  CarouselView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 11/11/21.
//

import UIKit
import CircularCarousel

final class CarouselView<T> : UIView {
    
    // MARK: - PROPERTIES
    
    private var carouselLayout: CarouselLayoutModel
    private var carouselItems: [T]?
    weak var delegate: ContainerCarouselViewProtocol?
    
    // MARK: - INITIALIZER
    
    public init(carouselLayout: CarouselLayoutModel) {
        self.carouselLayout = carouselLayout
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var carousel: CircularCarousel = {
        let setupComponent = CircularCarousel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.delegate = self
        setupComponent.panEnabled = true
        setupComponent.dataSource = self
        setupComponent.isUserInteractionEnabled = true
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updateCarouselItems(with itemList: [T]) {
        carouselItems = itemList
        DispatchQueue.main.async {
            self.carousel.reloadData()
        }
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(carousel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            carousel.topAnchor.constraint(equalTo: topAnchor),
            carousel.trailingAnchor.constraint(equalTo: trailingAnchor),
            carousel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -CarouselMetrics.shortMargin),
            carousel.leadingAnchor.constraint(equalTo: leadingAnchor),
            carousel.heightAnchor.constraint(equalToConstant: CarouselMetrics.carouselHeight)
        ])
    }
}

// MARK: - EXTENSIONS

extension CarouselView: CircularCarouselDataSource, CircularCarouselDelegate {
    
    func numberOfItems(inCarousel carousel: CircularCarousel) -> Int {
        guard let carouselItems = carouselItems?.count else  { return CarouselMetrics.minimumNumberOfEmptyElements }
        return carouselItems
    }
    
    func carousel(_ carousel: CircularCarousel, didSelectItemAtIndex index: Int) {
        guard let carouselItems = carouselItems else { return }
        delegate?.didTapCarouselItem(with: carouselItems[index])
    }
    
    func startingItemIndex(inCarousel carousel: CircularCarousel) -> Int {
        return 0
    }
    
    func carousel(_ carousel: CircularCarousel, spacingForOffset offset: CGFloat) -> CGFloat {
        return carouselLayout.offset
    }
    
    func carousel(_ carousel: CircularCarousel, currentItemDidChangeToIndex index: Int) {
        guard  let carouselItems = carouselItems else { return }
        if carouselItems.isEmpty { return }
        delegate?.currentDisplayedCarouselItem(with: index)
        delegate?.currentDisplayedCarouselItem(with: carouselItems[index])
    }
    
    func carousel(_: CircularCarousel, viewForItemAt indexPath: IndexPath, reuseView view: UIView?) -> UIView {
        guard let delegate = delegate else {
            let standardCellView = UIView(frame: carouselLayout.cellSize)
            standardCellView.layer.cornerRadius = CarouselMetrics.cornerRadius
            standardCellView.backgroundColor = .lightGray
            return standardCellView
        }
        guard  let carouselItems = carouselItems else { return delegate.setupCarouselCellView(with: nil as T?) }
        if carouselItems.isEmpty { return UIView() }
        if indexPath.row == 0 {
            delegate.currentDisplayedCarouselItem(with: carouselItems[0])
        }
        return delegate.setupCarouselCellView(with: carouselItems[indexPath.row])
    }
    
    func carousel<T>(_ carousel: CircularCarousel, valueForOption option: CircularCarouselOption, withDefaultValue defaultValue: T) -> T {
        switch option {
            case .scaleMultiplier:
                return carouselLayout.scaleMultiplier as? T ?? defaultValue
            case .minScale:
                return carouselLayout.minScale as? T ?? defaultValue
            case .maxScale:
                return carouselLayout.maxScale as? T ?? defaultValue
            case .itemWidth:
                return carouselLayout.width as? T ?? defaultValue
            default:
                return defaultValue
        }
    }
}

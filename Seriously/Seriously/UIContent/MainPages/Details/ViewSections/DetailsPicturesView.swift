//
//  DetailsPicturesView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 29/11/21.
//

import UIKit

protocol DetailsPictureViewProtocol: AnyObject {
    func loadImage(from urlString: String) -> UIImage?
}

class DetailsPictureView: UIView {
    
    // MARK: - CONSTANTS
    
    private struct Constants {
        static let titleLabelText = "Pictures"
    }
    
    private enum Metrics {
        static let carouselCellSize: CGRect = CGRect(x: 0, y: 0, width: 150, height: 100)
        static let carouselMinScale: CGFloat = 0.5
        static let carouselMaxScale: CGFloat = 1.9
        static let carouselScaleMultiplier: CGFloat = 0.4
        static let carouselOffset: CGFloat = 3.4
        static let carouselWidth: CGFloat = 80
        static let fontSize: CGFloat = 18
        static let standardMargin: CGFloat = 24
    }
    
    // MARK: - PROPERTIES
    
    weak var delegate: DetailsPictureViewProtocol?
    
    // MARK: - INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let setupComponent = UILabel(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.text = Constants.titleLabelText
        setupComponent.numberOfLines = 1
        setupComponent.font = .roboto(ofSize: Metrics.fontSize, weight: .regular)
        setupComponent.textColor = .white
        return setupComponent
    }()
    
    private lazy var carouselView: CarouselView<String> = {
        let carouselLayout = CarouselLayoutModel(cellSize: Metrics.carouselCellSize,
                                            minScale: Metrics.carouselMinScale,
                                            maxScale: Metrics.carouselMaxScale,
                                            scaleMultiplier: Metrics.carouselScaleMultiplier,
                                            offset: Metrics.carouselOffset,
                                            width: Metrics.carouselWidth)
        let setupComponent = CarouselView<String>(carouselLayout: carouselLayout)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.isUserInteractionEnabled = true
        setupComponent.delegate = self
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updatePicturesView(with imageList: [String]) {
        carouselView.updateCarouselItems(with: imageList)
    }

    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(carouselView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.standardMargin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.standardMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.standardMargin),
            
            carouselView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            carouselView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: trailingAnchor),
            carouselView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.standardMargin)
        ])
    }
}

extension DetailsPictureView: ContainerCarouselViewProtocol {
    func setupCarouselCellView<T>(with cellForRowData: T?) -> UIView {
        let carouselCell = DetailsCarouselCellView()
        carouselCell.pictureView.image = nil
        carouselCell.isUserInteractionEnabled = true
        guard  let carouselItems = cellForRowData as? String else { return carouselCell }
        DispatchQueue.global().async {
            guard let loadedImage = self.delegate?.loadImage(from: carouselItems) else { return }
            DispatchQueue.main.async {
                carouselCell.pictureView.image = loadedImage
            }
        }
        return carouselCell
    }
}

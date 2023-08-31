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
        static let controlPageViewSize: CGSize = CGSize(width: 8, height: 8)
        static let carouselCellSize: CGRect = CGRect(x: 0, y: 0, width: 150, height: 100)
        static let carouselMinScale: CGFloat = 0.5
        static let carouselMaxScale: CGFloat = 1.9
        static let carouselScaleMultiplier: CGFloat = 0.4
        static let carouselOffset: CGFloat = 3.4
        static let carouselWidth: CGFloat = 80
        static let fontSize: CGFloat = 18
        static let standardMargin: CGFloat = 24
        static let bigMargin: CGFloat = 32
        static let spacing: CGFloat = 8
        static let smallRadius: CGFloat = 4
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
    
    private lazy var pageControlStackView: UIStackView = {
        let setupComponent = UIStackView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.axis = .horizontal
        setupComponent.spacing = Metrics.spacing
        setupComponent.distribution = .fillEqually
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updatePicturesView(with imageList: [String]) {
        carouselView.updateCarouselItems(with: imageList)
        populatePageControlStackView(with: imageList.count)
    }

    // MARK: - PRIVATE METHODS
    
    private func getPageControlView() -> UIView {
        let controlView = UIView()
        controlView.backgroundColor = .lightGray
        controlView.heightAnchor.constraint(equalToConstant: Metrics.controlPageViewSize.height).isActive = true
        controlView.widthAnchor.constraint(equalToConstant: Metrics.controlPageViewSize.width).isActive = true
        controlView.layer.cornerRadius = Metrics.smallRadius
        return controlView
    }
    
    private func populatePageControlStackView(with numberOfPictures: Int) {
        if numberOfPictures == 0 || numberOfPictures > 10 { return }
        for _ in 1...numberOfPictures {
            pageControlStackView.addArrangedSubview(getPageControlView())
        }
        currentDisplayedCarouselItem(with: 0)
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(carouselView)
        addSubview(pageControlStackView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.standardMargin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.standardMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.standardMargin),
            
            carouselView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            carouselView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            pageControlStackView.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: -Metrics.standardMargin),
            pageControlStackView.centerXAnchor.constraint(equalTo: carouselView.centerXAnchor),
            pageControlStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.bigMargin)
        ])
    }
}

extension DetailsPictureView: ContainerCarouselViewProtocol {
    
    func currentDisplayedCarouselItem(with index: Int) {
        if pageControlStackView.subviews.isEmpty { return }
        pageControlStackView.subviews.forEach { $0.backgroundColor = .gray500 }
        pageControlStackView.subviews[index].backgroundColor = .gray200
    }
    
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

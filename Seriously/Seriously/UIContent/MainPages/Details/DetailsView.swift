//
//  DetailsView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 18/11/21.
//

import UIKit

class DetailsView: UIView {
    
    // MARK: - PROPERTIES
    
    weak var delegate: DetailsViewProtocol?
    
    // MARK: - INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let setupComponent = UIScrollView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.contentInsetAdjustmentBehavior = .never
        setupComponent.bounces = false
        setupComponent.scrollsToTop = true
        setupComponent.showsVerticalScrollIndicator = false
        return setupComponent
    }()
    
    private lazy var containerStackView: UIStackView = {
        let setupComponent = UIStackView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.axis = .vertical
        setupComponent.distribution = .fill
        return setupComponent
    }()
    
    private var modalDraggerLineView: ModalDraggerLine = {
        let setupComponent = ModalDraggerLine(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        return setupComponent
    }()

    private lazy var headerView: DetailsHeaderView = {
        let setupComponent = DetailsHeaderView()
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        return setupComponent
    }()
    
    private lazy var descriptionView: DetailsDescriptionView = {
        let setupComponent = DetailsDescriptionView()
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        return setupComponent
    }()
    
    private lazy var pictureView: DetailsPictureView = {
        let setupComponent = DetailsPictureView()
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.delegate = self
        return setupComponent
    }()
    
    // MARK: - PUBLIC METHODS
    
    public func updateDetailsView(with entity: TvShowDetailsPlanData) {
        headerView.updateHeaderView(with: entity)
        descriptionView.updateDescriptionView(with: entity)
        pictureView.updatePicturesView(with: entity.pictures)
        setupView()
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
        customizeView()
    }
    
    private func buildViewHierarchy() {
        self.addSubview(scrollView)
        self.addSubview(modalDraggerLineView)
        scrollView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(headerView)
        containerStackView.addArrangedSubview(descriptionView)
        containerStackView.addArrangedSubview(pictureView)
    }
    
    private func addConstraints() {
        let containerStackViewHeightConstraint = containerStackView.heightAnchor.constraint(equalTo: heightAnchor)
        containerStackViewHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            containerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerStackView.widthAnchor.constraint(equalTo: widthAnchor),
            containerStackViewHeightConstraint,
            
            modalDraggerLineView.topAnchor.constraint(equalTo: containerStackView.topAnchor),
            modalDraggerLineView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            modalDraggerLineView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor)
        ])
    }
    
    private func customizeView() {
        self.backgroundColor = .indigo500
    }
}

extension DetailsView: DetailsPictureViewProtocol {
    func loadImage(from urlString: String) -> UIImage? {
        delegate?.loadImage(from: urlString)
    }
}

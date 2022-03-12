//
//  DetailsCarouselCellView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 29/11/21.
//

import UIKit

class DetailsCarouselCellView: UICollectionViewCell {
    
    // MARK: - CONSTANTS
    
    private enum Metrics {
        static let cornerRadius: CGFloat = 4
        static let pictureViewSize: CGSize = CGSize(width: 150, height: 100)
    }
    
    // MARK: - PROPERTIES
    
    weak var delegate: HomeCollectionCellViewProtocol?
    
    // MARK: - INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    public lazy var pictureView: UIImageView = {
        let setupComponent = UIImageView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.backgroundColor = .lightGray
        setupComponent.layer.cornerRadius = Metrics.cornerRadius
        setupComponent.contentMode = .scaleToFill
        setupComponent.clipsToBounds = true
        setupComponent.isUserInteractionEnabled = false
        return setupComponent
    }()

    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        self.addSubview(pictureView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            pictureView.heightAnchor.constraint(equalToConstant: Metrics.pictureViewSize.height),
            pictureView.widthAnchor.constraint(equalToConstant: Metrics.pictureViewSize.width),
            pictureView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pictureView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

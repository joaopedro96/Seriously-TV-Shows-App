//
//  FavoritesCarouselCellView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 13/11/21.
//

import UIKit

class FavoritesCarouselCellView: UICollectionViewCell {
    
    // MARK: - CONSTANTS
    
    private enum Metrics {
        static let posterCarouselSize: CGSize = CGSize(width: 100, height: 150)
        static let posterCorderRadius: CGFloat = 8
    }
    
    // MARK: - PROPERTIES
    
    private var buttonState: Bool = false
    
    // MARK: - INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PUBLIC UI
    
    public lazy var posterView: UIImageView = {
        let setupComponent = UIImageView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.backgroundColor = .lightGray
        setupComponent.layer.cornerRadius = Metrics.posterCorderRadius
        setupComponent.contentMode = .scaleToFill
        setupComponent.clipsToBounds = true
        setupComponent.isUserInteractionEnabled = true
        return setupComponent
    }()

    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(posterView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            posterView.heightAnchor.constraint(equalToConstant: Metrics.posterCarouselSize.height),
            posterView.widthAnchor.constraint(equalToConstant: Metrics.posterCarouselSize.width),
            posterView.centerYAnchor.constraint(equalTo: centerYAnchor),
            posterView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

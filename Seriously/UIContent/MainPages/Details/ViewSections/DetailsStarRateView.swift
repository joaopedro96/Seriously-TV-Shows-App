//
//  DetailsStarRateView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 02/03/22.
//

import UIKit

class DetailsStarRateView: UIView {
    
    // MARK: - PROPERTIES
    
    private var rateImageState: Bool
    
    // MARK: - INITIALIZER
    
    init(starState: Bool) {
        self.rateImageState = starState
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var rateImage: UIImageView = {
        let setupComponent = UIImageView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.backgroundColor = .indigo500
        setupComponent.contentMode = .scaleAspectFit
        setupComponent.clipsToBounds = true
        return setupComponent
    }()
    
    // MARK: - PRIVATE METHODS
    
    private func setRateImage() {
        if rateImageState {
            rateImage.image = .starIconEnable
        } else {
            rateImage.image = .starIconDisable
        }
    }

    // MARK: - SETUP VIEW
    
    private func setupView() {
        setRateImage()
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(rateImage)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            rateImage.topAnchor.constraint(equalTo: topAnchor),
            rateImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            rateImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            rateImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

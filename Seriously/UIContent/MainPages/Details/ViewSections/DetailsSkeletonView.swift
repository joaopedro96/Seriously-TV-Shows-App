//
//  DetailsSkeletonView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 28/05/22.
//

import UIKit
import SkeletonView

class DetailsSkeletonView: UIView {
    
    // MARK: - METRICS
    
    private enum Metrics {
        static let standardMargin: CGFloat = 24
        static let bigMargin: CGFloat = 32
        static let hugeMargin: CGFloat = 48
        
        static let spacing: CGFloat = 8
        static let bigSpacing: CGFloat = 16
        
        static let mediumSkeletonHeight: CGFloat = 12
        static let skeletonHeight: CGFloat = 24
        static let bigSkeletonHeight: CGFloat = 32
        static let skeletonPictureHeight: CGFloat = 180
        static let skeletonPosterHeight: CGFloat = 350

        static let screenWidth = UIScreen.main.bounds.width
        static let skeletonStandardWidth = UIScreen.main.bounds.width - 2 * (standardMargin)
        
        static let tinyCornerRadius: Float = 3
        static let cornerRadius: CGFloat = 8

    }
            
    // MARK: - INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        enableAnimatedSkeleton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var headerStackView: UIStackView = {
        let setupComponent = UIStackView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.axis = .vertical
        setupComponent.spacing = Metrics.bigSpacing
        setupComponent.distribution = .fill
        setupComponent.alignment = .center
        setupComponent.isSkeletonable = true
        return setupComponent
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let setupComponent = UIStackView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.axis = .vertical
        setupComponent.spacing = Metrics.spacing
        setupComponent.distribution = .fill
        setupComponent.alignment = .leading
        setupComponent.isSkeletonable = true
        return setupComponent
    }()
    
    private lazy var topicStackView: UIStackView = {
        let setupComponent = UIStackView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.axis = .vertical
        setupComponent.spacing = Metrics.spacing
        setupComponent.distribution = .fill
        setupComponent.alignment = .leading
        setupComponent.isSkeletonable = true
        return setupComponent
    }()
    
    private lazy var pictureView: UIView = {
        let setupComponent = UIView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.isSkeletonable = true
        setupComponent.skeletonCornerRadius = Float(Metrics.cornerRadius)
        return setupComponent
    }()
    
    // MARK: - PRIVATE METHODS
    
    private func enableAnimatedSkeleton() {
        self.isSkeletonable = true
        self.showAnimatedSkeleton()
    }
    
    private func makeNewSkeletonView(height: CGFloat, relativeWidth: CGFloat? = nil) -> UIView {
        let skeletonView = UIView(frame: .zero)
        skeletonView.translatesAutoresizingMaskIntoConstraints = false
        skeletonView.isSkeletonable = true
        skeletonView.skeletonCornerRadius = Metrics.tinyCornerRadius
        skeletonView.heightAnchor.constraint(equalToConstant: height).isActive = true
        if let relativeWidth = relativeWidth {
            skeletonView.widthAnchor.constraint(equalToConstant: Metrics.screenWidth * relativeWidth).isActive = true
        } else {
            skeletonView.widthAnchor.constraint(equalToConstant: Metrics.skeletonStandardWidth).isActive = true
        }
        return skeletonView
    }

    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(headerStackView)
        headerStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.skeletonPosterHeight, relativeWidth: 1))
        headerStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.bigSkeletonHeight, relativeWidth: 0.8))
        headerStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.skeletonHeight, relativeWidth: 0.4))
        
        addSubview(descriptionStackView)
        descriptionStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.skeletonHeight, relativeWidth: 0.2))
        descriptionStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.mediumSkeletonHeight))
        descriptionStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.mediumSkeletonHeight))
        descriptionStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.mediumSkeletonHeight, relativeWidth: 0.5))
        
        addSubview(topicStackView)
        topicStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.mediumSkeletonHeight, relativeWidth: 0.2))
        topicStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.mediumSkeletonHeight, relativeWidth: 0.3))
        topicStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.mediumSkeletonHeight, relativeWidth: 0.15))
        topicStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.mediumSkeletonHeight, relativeWidth: 0.2))
        topicStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.mediumSkeletonHeight, relativeWidth: 0.3))
        topicStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.mediumSkeletonHeight, relativeWidth: 0.15))
        topicStackView.addArrangedSubview(makeNewSkeletonView(height: Metrics.mediumSkeletonHeight, relativeWidth: 0.4))
        
        addSubview(pictureView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            descriptionStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: Metrics.standardMargin),
            descriptionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.standardMargin),
            descriptionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.standardMargin),
            
            topicStackView.topAnchor.constraint(equalTo: descriptionStackView.bottomAnchor, constant: Metrics.standardMargin),
            topicStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.standardMargin),
            topicStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.standardMargin),
            
            pictureView.topAnchor.constraint(equalTo: topicStackView.bottomAnchor, constant: Metrics.standardMargin),
            pictureView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.hugeMargin),
            pictureView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.hugeMargin),
            pictureView.heightAnchor.constraint(equalToConstant: Metrics.skeletonPictureHeight),
            pictureView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.bigMargin)
        ])
    }
}

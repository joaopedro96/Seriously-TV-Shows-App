//
//  ModalDragLineView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 21/11/21.
//

import UIKit

class ModalDraggerLine: UIView {
    
    // MARK: - CONSTANTS

    private enum Metrics {
        static let dragLineSize = CGSize(width: 100, height: 8)
        static let cornerRadius: CGFloat = 8
        static let shortMargin: CGFloat = 12
    }
    
    // MARK: - INITIALIZER
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var draggerLine: UIView = {
        let setupComponent = UIView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.heightAnchor.constraint(equalToConstant: Metrics.dragLineSize.height).isActive = true
        setupComponent.widthAnchor.constraint(equalToConstant: Metrics.dragLineSize.width).isActive = true
        setupComponent.layer.cornerRadius = Metrics.cornerRadius
        setupComponent.isUserInteractionEnabled = true
        setupComponent.backgroundColor = .gray300
        return setupComponent
    }()

    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(draggerLine)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            draggerLine.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.shortMargin),
            draggerLine.centerXAnchor.constraint(equalTo: centerXAnchor),
            draggerLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.shortMargin)
        ])
    }
}

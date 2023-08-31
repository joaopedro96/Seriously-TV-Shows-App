//
//  SearchBar.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 31/10/21.
//

import UIKit

protocol SearchBarProtocol: AnyObject {
    func didMakeSearch(for text: String)
    func didTapClear()
}

extension SearchBarProtocol {
    func didTapClear() { }
}

class SearchBar: UIView {
    
    // MARK: - CONSTANTS
    
    private struct Constants {
        static let placeholderText = "Type to search"
    }
    
    private enum Metrics {
        static let searchBarCornerRadius: CGFloat = 16
        static let searchBarHeight: CGFloat = 36
        static let searchBarLeftPadding: Double = 24
        static let searchBarRightPadding: Double = 32
        static let fontSizeMedium: CGFloat = 16
        static let textFieldPadding: CGFloat = 10
        static let shortMargin: CGFloat = 12
        static let margin: CGFloat = 16
        static let searchIconSize = CGSize(width: 36, height: 36)
        static let cancelIconSize = CGSize(width: 18, height: 18)
    }
    
    // MARK: - PROPERTIES
    
    private var isEditingSearchBar: Bool = false
    weak var delegate: SearchBarProtocol?
    
    // MARK: - INITALIZERS
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var searchTextField: UITextField = {
        let setupComponent = UITextField(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.heightAnchor.constraint(equalToConstant: Metrics.searchBarHeight).isActive = true
        setupComponent.layer.cornerRadius = Metrics.searchBarCornerRadius
        setupComponent.backgroundColor = .indigo600
        setupComponent.textColor = .white
        setupComponent.font = .roboto(ofSize: Metrics.fontSizeMedium, weight: .regular)
        setupComponent.leftView = setPadding(with: Metrics.searchBarLeftPadding)
        setupComponent.rightView = setPadding(with: Metrics.searchBarRightPadding)
        setupComponent.leftViewMode = .always
        setupComponent.rightViewMode = .always
        setupComponent.delegate = self
        setupComponent.attributedPlaceholder = NSAttributedString(
            string: Constants.placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray400])
        return setupComponent
    }()
    
    private func setPadding(with padding: Double) -> UIView {
        let viewPadding = UIView(frame: CGRect(x: 0.0, y: 0.0, width: padding, height: 2))
        return viewPadding
    }
    
    private lazy var searchIcon: UIImageView = {
        let setupComponent = UIImageView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.heightAnchor.constraint(equalToConstant: Metrics.searchIconSize.height).isActive = true
        setupComponent.widthAnchor.constraint(equalToConstant: Metrics.searchIconSize.width).isActive = true
        setupComponent.image = .searchIcon
        setupComponent.contentMode = .scaleToFill
        return setupComponent
    }()
    
    private lazy var cancelIcon: UIImageView = {
        let setupComponent = UIImageView(frame: .zero)
        setupComponent.translatesAutoresizingMaskIntoConstraints = false
        setupComponent.heightAnchor.constraint(equalToConstant: Metrics.cancelIconSize.height).isActive = true
        setupComponent.widthAnchor.constraint(equalToConstant: Metrics.cancelIconSize.width).isActive = true
        setupComponent.image = .cancelIcon
        setupComponent.contentMode = .scaleToFill
        setupComponent.isHidden = true
        setupComponent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapClear)))
        setupComponent.isUserInteractionEnabled = true
        return setupComponent
    }()
    
    // MARK: - PRIVATE METHODS
    
    @objc private func didTapClear() {
        searchTextField.text = ""
        cancelIcon.isHidden = true
        delegate?.didTapClear()
    }
    
    // MARK: - PUBLIC METHODS
    
    public func closeKeyboard() {
        if isEditingSearchBar {
            searchTextField.endEditing(true)
        }
    }
    
    // MARK: - SETUP VIEW
    
    private func setupView() {
        buildViewHierarchy()
        addConstraints()
    }
    
    private func buildViewHierarchy() {
        addSubview(searchTextField)
        addSubview(searchIcon)
        addSubview(cancelIcon)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchIcon.topAnchor.constraint(equalTo: topAnchor),
            searchIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.margin),
            
            searchTextField.topAnchor.constraint(equalTo: searchIcon.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: Metrics.shortMargin),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.margin),
            searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.margin),
            
            cancelIcon.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            cancelIcon.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: -Metrics.textFieldPadding)
        ])
    }
}

extension SearchBar: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text != "" {
            cancelIcon.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            guard let currentText = textField.text else { return true }
            let maskText = currentText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+").folding(options: .diacriticInsensitive, locale: .current)
            delegate?.didMakeSearch(for: maskText)
        } else {
            didTapClear()
        }
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            cancelIcon.isHidden = true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEditingSearchBar = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isEditingSearchBar = false
    }
}

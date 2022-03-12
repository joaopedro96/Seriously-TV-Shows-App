//
//  CustomFonts.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 01/11/21.
//

import UIKit

extension UIFont {
    
    // MARK: - CUSTOM FONTS
    
    static internal func roboto(ofSize currentSize: CGFloat, weight: RobotoFontWeight) -> UIFont {
        let weightName = getRobotoWeightName(for: weight)
        let customFontName = "Roboto-\(weightName)"
        guard let customFont = UIFont(name: customFontName, size: currentSize) else {
            fatalError("Failed to load the '\(customFontName)' font.")
        }
        return customFont
    }
    
    static internal func robotoItalic(ofSize currentSize: CGFloat, weight: RobotoFontWeight) -> UIFont {
        let weightName = getRobotoWeightName(for: weight)
        let customFontName = "Roboto-\(weightName)Italic"
        guard let customFont = UIFont(name: customFontName, size: currentSize) else {
            fatalError("Failed to load the '\(customFontName)' font.")
        }
        return customFont
    }
    
    // MARK: - SWITCH WEIGHT
    
    private static func getRobotoWeightName(for weight: RobotoFontWeight) -> String {
        var fontWeightName: String = ""
        switch weight {
        case .thin:
            fontWeightName = "Thin"
        case .light:
            fontWeightName = "Light"
        case .regular:
            fontWeightName = "Regular"
        case .medium:
            fontWeightName = "Medium"
        case .bold:
            fontWeightName = "Bold"
        case .extraBold:
            fontWeightName = "Black"
        }
        return fontWeightName
    }
    
    // MARK: - ENUM
    
    public enum RobotoFontWeight {
        case thin //100
        case light //300
        case regular //400
        case medium //500
        case bold //700
        case extraBold //900
    }
}

//
//  CustomImages.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 31/10/21.
//

import UIKit

extension UIImage {
    
    // MARK: - BANNERS
    
    public class var thePunisherBanner: UIImage {
        return initialize(with: "the_punisher")
    }
    
    public class var arcaneBanner: UIImage {
        return initialize(with: "arcane_banner")
    }
    
    public class var arcanePoster: UIImage {
        return initialize(with: "arcane_poster")
    }
    
    // MARK: - ICONS
    
    public class var cancelIcon: UIImage {
        return initialize(with: "cancel_icon")
    }
    
    public class var checkedHeartIcon: UIImage {
        return initialize(with: "heart_icon_enable")
    }
    
    public class var uncheckedHeartIcon: UIImage {
        return initialize(with: "heart_icon_disable")
    }
    
    public class var searchIcon: UIImage {
        return initialize(with: "search_icon")
    }
    
    public class var starIconEnable: UIImage {
        return initialize(with: "star_icon_enable")
    }
    
    public class var starIconDisable: UIImage {
        return initialize(with: "star_icon_disable")
    }
    
    public class var systemHouseFillIcon: UIImage {
        return initializeSystemImage(with: "house.fill")
    }
    
    public class var systemHeartIcon: UIImage {
        return initializeSystemImage(with: "heart")
    }
    
    public class var systemHeartFillIcon: UIImage {
        return initializeSystemImage(with: "heart.fill")
    }
    
    // MARK: - INITIALIZER
    
    fileprivate class func initialize(with name: String) -> UIImage {
        return UIImage(named: name, in: Bundle.main, compatibleWith: nil) ?? UIImage()
    }
    
    fileprivate class func initializeSystemImage(with name: String) -> UIImage {
        return UIImage(systemName: name, compatibleWith: nil) ?? UIImage()
    }
}

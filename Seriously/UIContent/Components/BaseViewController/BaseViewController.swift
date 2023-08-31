//
//  BaseViewController.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 02/03/22.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

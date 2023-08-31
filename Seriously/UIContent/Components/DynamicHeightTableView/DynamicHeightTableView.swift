//
//  DetailsEpisodeTableView.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 01/06/22.
//

import Foundation
import UIKit

class DynamicHeightTableView: UITableView {
    override var intrinsicContentSize: CGSize {
      self.layoutIfNeeded()
      return self.contentSize
    }

    override var contentSize: CGSize {
      didSet{
        self.invalidateIntrinsicContentSize()
      }
    }

    override func reloadData() {
      super.reloadData()
      self.invalidateIntrinsicContentSize()
    }
}

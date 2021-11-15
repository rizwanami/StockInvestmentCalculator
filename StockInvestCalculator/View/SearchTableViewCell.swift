//
//  SearchTableViewCell.swift
//  StockInvestCalculator
//
//  Created by Rizwana on 6/8/21.
//

import Foundation
import UIKit
import Combine
class SearchTableViewCell : UITableViewCell {
   @IBOutlet weak var assetNameLabel : UILabel!
   @IBOutlet weak var assetSymbolLabel : UILabel!
   @IBOutlet weak var assetTypeLabel : UILabel!
   func configure(for searchResult : SearchResult){
      //assetNameLabel.text = searchResult.
      assetNameLabel.text = searchResult.name
      assetSymbolLabel.text = searchResult.symbol
      assetTypeLabel.text = searchResult.type.appending(" ").appending(searchResult.currency)
   }
}

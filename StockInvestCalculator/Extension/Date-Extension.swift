//
//  Extension-Date.swift
//  StockInvestCalculator
//
//  Created by Rizwana on 6/17/21.
//

import Foundation
extension Date {
   var MMYYFormat : String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMMM yyyy"
      return dateFormatter.string(from: self)
   }
}

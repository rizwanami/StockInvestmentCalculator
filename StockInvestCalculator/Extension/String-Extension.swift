//
//  String-Extension.swift
//  StockInvestCalculator
//
//  Created by Rizwana on 6/16/21.
//

import Foundation
extension String {
   func addBaracket()-> String{
      return "(\(self))"
   }
   func prefix(_ text : String)-> String{
      return text + self
   }
}

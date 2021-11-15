//
//  SearchResults.swift
//  StockInvestCalculator
//
//  Created by Rizwana on 6/10/21.
//

import Foundation
struct SearchResults : Decodable {
   let items : [SearchResult]
   enum CodingKeys : String, CodingKey {
      case items = "bestMatches"
      
   }
   
}
struct SearchResult : Decodable {
   let symbol : String
   let name : String
   let currency : String
   let type : String
   
   enum CodingKeys : String , CodingKey {
      case symbol =  "1. symbol"
      case name =  "2. name"
      case currency =  "8. currency"
      case type = "3. type"
   }
}

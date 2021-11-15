//
//  APIServices.swift
//  StockInvestCalculator
//
//  Created by Rizwana on 6/10/21.
//

import Foundation
import Combine
// Random key selection

struct APIServices{
   enum APIServicesError : Error{
      case encoding
      case badRequest
   }
   var API_Key : String {
      return API_Keys.randomElement() ?? ""
   }
   let API_Keys = ["ZHWX6LWGHLQX3Q4E", "WK2N8TA68Y8S96IY", "M7PENTC5H52QP7CZ", "4TSWKYZJ9505F703", "ZA7QUOIDINQ8PG4X", "1JPICUF9TUZUJ28R"]
   
   func fetchSearch(symbol : String) -> AnyPublisher<SearchResults, Error> {
      
      /*this publisher eithr return a publisher or error so in guard we have return some guard of error if no publishe is returnong  */
     var result = pasrseQueryText(text: symbol)
      var symbol = String()
      switch result {
      case .success(let query):
         symbol = query
      case .failure(let error):
         return Fail(error: error).eraseToAnyPublisher()
      }
      let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(symbol)&apikey=\(API_Key)"
      let urlResult = parseURL(urlString: urlString)
      switch urlResult {
      case .success(let url):
         return  URLSession.shared.dataTaskPublisher(for: url).map({$0.data}).decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on : RunLoop.main)
            .eraseToAnyPublisher()
      case .failure(let error):
         return Fail(error: error).eraseToAnyPublisher()
      }
      
      
      
      
   }
   
   func fetchTimeSeriesMonthlyAdjusted(symbol : String) -> AnyPublisher<TimeSeriesMonthlyAdjusted , Error> {
       let result = pasrseQueryText(text: symbol)
      var symbol = String()
      switch result {
      case .success(let query):
         symbol = query
      case .failure(let error):
      return Fail(error: error).eraseToAnyPublisher()
      }
      print("symbol", symbol)
         let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(symbol)&apikey=\(API_Key)"
      
      let urlResult = parseURL(urlString: urlString)
     
      switch urlResult {
      case .success(let url):
         return  URLSession.shared.dataTaskPublisher(for: url).map({$0.data}).decode(type: TimeSeriesMonthlyAdjusted.self, decoder: JSONDecoder())
            .receive(on : RunLoop.main)
            .eraseToAnyPublisher()
      case .failure(let erorr):
         print("The error in ", erorr)
         return Fail(error: erorr).eraseToAnyPublisher()
      }
         
         
      }
   // Returning  A Result eithr String or error we check with any spavce
   func pasrseQueryText(text : String)-> Result<String , Error> {
   if let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
      return .success(query)
   } else {
      return .failure(APIServicesError.encoding)
   }
   }
   func parseURL(urlString : String)->Result<URL, Error>{
      
      if let url = URL(string: urlString) {
         return .success(url)
      } else {
         return .failure(APIServicesError.badRequest)
      }
      
   }
   
}

/*
  bryntmp+nn2vo@gmail.com
  WK2N8TA68Y8S96IY
  
  f.le.tch.erh.ar.v.eytmp@gmail.com
  M7PENTC5H52QP7CZ
  
  jocktmp+xafno@gmail.com
  4TSWKYZJ9505F703
  
  sa.lva.tot.uck.e.r.tm.p@gmail.com
  ZA7QUOIDINQ8PG4X
 
 ja.v.i.er.fran.c.is.cot.mp@gmail.com
 ZHWX6LWGHLQX3Q4E.
 lonytmp+jaisy@gmail.com
 1JPICUF9TUZUJ28R.
  */

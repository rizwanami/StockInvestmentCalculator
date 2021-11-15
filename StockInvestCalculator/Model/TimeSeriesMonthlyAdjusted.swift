//
//  TimeSeriesMonthlyAdjusted.swift
//  StockInvestCalculator
//
//  Created by Rizwana on 6/14/21.
//

import Foundation
struct TimeSeriesMonthlyAdjusted : Decodable{
   let meta : Meta
   let TimeSeries : [String : OHLC]
   enum CodingKeys : String , CodingKey {
      case meta = "Meta Data"
      case TimeSeries = "Monthly Adjusted Time Series"
   }
   func getMontInfo()->[MonthInfo]{
      var montsInfo : [MonthInfo] = []
      let sortedTime = TimeSeries.sorted(by: {
         $0.key > $1.key
         
      })
      
      //1) iterarte over dicttionary of Timeseries key and value
      // 2) store key of Timeseries in date format
      // create monthInfo object which take month as key of Timeseries in date format
      //adjustedclose = open * (adjustedClose/ close)
      sortedTime.forEach({ (key, ohlc) in
         
      
         
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         if let date = dateFormatter.date(from: key){
         let adjustedOpen = getAdjustedOpen(ohlc: ohlc)
         var monthonfo = MonthInfo(month: date, adjustedOpen: adjustedOpen, adjustedClose:
         Double(ohlc.adjustedClose)!)
         montsInfo.append(monthonfo)
      }
      })
      
      
      
     // print(sortedTime)
        return montsInfo
      }
   func getAdjustedOpen(ohlc : OHLC)-> Double{
      
      return  Double(ohlc.open)! * (Double(ohlc.adjustedClose)! / Double(ohlc.close)!)
   }
  
      
   }


struct Meta : Decodable {
   let symbol : String
   enum CodingKeys : String , CodingKey {
      case symbol = "2. Symbol"
   }
   
}
   
   struct OHLC : Decodable {
      let open : String
      let close  : String
      let adjustedClose : String
      
      enum CodingKeys : String, CodingKey {
         case open =  "1. open"
         case  close =  "4. close"
         case adjustedClose =  "5. adjusted close"
      }
      
      
   
}
struct MonthInfo {
   let month : Date
   let adjustedOpen : Double
   let adjustedClose : Double
   }
/*
 "1. open": "143.8100",
             "2. high": "148.5150",
 "4. close": "150.0300",
             "5. adjusted close": "150.0300",
 
 "Meta Data"
 */

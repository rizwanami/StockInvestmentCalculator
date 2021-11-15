//
//  dcaServices.swift

//DollarCostAverageServices
//  StockInvestCalculator
//
//  Created by Rizwana on 6/18/21.
//

import Foundation
struct DCAServices {
   func calculate(asset : Asset , intialInvesmentAmount : Double, monthlyCostAveragingAmount : Double, initialDateOfInvestmentIndex : Int  )-> DCAResult{
      let investmentAmount = getInvestmentAmount(intialInvesmentAmount: intialInvesmentAmount, monthlyCostAveragingAmount: monthlyCostAveragingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
      let latestSharePrice = getLatestSharePrice(asset: asset)
      print("latestSharePrice \(latestSharePrice)")
      let numberOfShares = getNumberOfshares(asset: asset, intialInvesmentAmount: intialInvesmentAmount, monthlyCostAveragingAmount: monthlyCostAveragingAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
      
      let currentValue = getCurrentValue(numbersOfShare: numberOfShares, latestSharePrice: latestSharePrice)
      
      let isProfitable = currentValue > investmentAmount
      let gain = currentValue - investmentAmount
      let yield = gain / investmentAmount
      let returnValue = getAnnualReturn(currentValue: currentValue, investmentAmount: investmentAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
      return .init(currentValue: currentValue, InvestmentAmount: investmentAmount, gain: gain, returnValue: returnValue, yield: yield, isProfitable: isProfitable)
      
   }
   func getInvestmentAmount(intialInvesmentAmount : Double, monthlyCostAveragingAmount : Double, initialDateOfInvestmentIndex : Int )-> Double
   {
      var totalAmount = Double()
      totalAmount += intialInvesmentAmount
      let dollarCostAveragingAmount = initialDateOfInvestmentIndex.doubleValue * monthlyCostAveragingAmount
      totalAmount += dollarCostAveragingAmount
      return totalAmount
      
   }
   func getCurrentValue(numbersOfShare : Double, latestSharePrice : Double)-> Double{
      return numbersOfShare * latestSharePrice
   }
   func getLatestSharePrice(asset : Asset)-> Double{
      return asset.timeSeriesMonthlyAdjusted.getMontInfo().first?.adjustedClose ?? 0   }
   func getNumberOfshares(asset : Asset , intialInvesmentAmount : Double, monthlyCostAveragingAmount : Double, initialDateOfInvestmentIndex : Int )-> Double{
      var totalshares = Double()
      let initialInvestmentOpenPrice = asset.timeSeriesMonthlyAdjusted.getMontInfo()[initialDateOfInvestmentIndex].adjustedOpen
      
      let initialInvestmentShares = intialInvesmentAmount / initialInvestmentOpenPrice
   
      totalshares += initialInvestmentShares
      asset.timeSeriesMonthlyAdjusted.getMontInfo().prefix(initialDateOfInvestmentIndex).forEach{(monthInfo) in
         let dcaInvesmentshare = monthlyCostAveragingAmount / monthInfo.adjustedOpen
         totalshares += dcaInvesmentshare
      }
      return totalshares
      
   }
   func getAnnualReturn(currentValue : Double, investmentAmount : Double, initialDateOfInvestmentIndex : Int )-> Double{
      let rate = currentValue / investmentAmount
      let years = (initialDateOfInvestmentIndex.doubleValue + 1) / 12
      
      return pow(rate, (1 / years)) - 1
      
   }
   
}

struct DCAResult {
   let currentValue : Double
   let InvestmentAmount : Double
   let gain : Double
   let returnValue : Double
   let yield : Double
   let isProfitable : Bool
}
/*
initialDateOfInvestmentIndex : Int?
intialInvesmentAmount : Int?
monthlyCostAveragingAmount : Int?
 */

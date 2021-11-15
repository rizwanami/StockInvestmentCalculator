//
//  AfterCalculationViewPresenter.swift
//  StockInvestCalculator
//
//  Created by Rizwana on 6/22/21.
//

import Foundation
import UIKit
struct AfterCalculationViewPresenter {
   func getCalulaterViewpresentation(result : DCAResult)-> CalcultorViewPresentation {
      let plusSymbol = result.isProfitable ? "+" : ""
      let currentValueLabelBackgroundColor : UIColor = (result.isProfitable == true) ? .systemGreen : .systemRed
      var currentValue =  result.currentValue.currencyFormat
      let investmentAmount = result.InvestmentAmount.toCurrencyFormat(hasDecimalPlaces: false)
      let gainLabel = result.gain.toCurrencyFormat(hasDecimalPlaces: false)
      let yieldLabelTextColor : UIColor = result.isProfitable ? .systemGreen : .systemRed
      let yieldLabel = result.yield.percentFormat.prefix(plusSymbol).addBracket()
      let annualReturnLabelTextColor : UIColor = result.isProfitable ? .systemGreen : .systemRed
      let annualReturn = result.returnValue.percentFormat
      
      return .init(currentValueLabelBackgroundColor: currentValueLabelBackgroundColor , currentValue: currentValue, investmentAmount: investmentAmount, gainLabel: gainLabel, yieldLabelTextColor: yieldLabelTextColor, yieldLabel: yieldLabel, annualReturnLabelTextColor: annualReturnLabelTextColor, annualReturn: annualReturn)
   }
   
}
struct CalcultorViewPresentation {
   
   var currentValueLabelBackgroundColor : UIColor
   var currentValue : String
   let investmentAmount : String
   let gainLabel : String
   let yieldLabelTextColor : UIColor
   let yieldLabel : String
   let annualReturnLabelTextColor : UIColor
   let annualReturn : String
   
  /*
    let isProfitable = result.isProfitable == true
    let plusSymbol = isProfitable ? "+" : ""
    self.currentValueLabel.backgroundColor = (result.isProfitable == true) ? .themeGreen : .themeRed
    self.currentValueLabel.text = result.currentValue.currencyFormat
    
    self.investmentAmountLabel.text = result.InvestmentAmount.toCurrencyFormat(hasDecimalPlaces: false)
    self.gainLabel.text = result.gain.toCurrencyFormat(hasDollarSymbol: false, hasDecimalPlaces: false)
    self.yieldLabel.textColor = isProfitable ? .systemGreen : .systemRed
    self.yieldLabel.textColor.text = result.yield.percentFormat.prefix(plusSymbol).addBracket()
    self.annualReturnLabel.textColor = isProfitable ? .systemGreen : .systemRed
    self.annualReturnLabel.text = result.returnValue.percentFormat
 
*/
}

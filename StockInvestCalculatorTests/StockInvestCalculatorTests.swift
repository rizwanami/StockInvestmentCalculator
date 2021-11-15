//
//  StockInvestCalculatorTests.swift
//  StockInvestCalculatorTests
//
//  Created by Rizwana on 6/20/21.
//

import XCTest
@testable import StockInvestCalculator

class StockInvestCalculatorTests: XCTestCase {
   var sut = DCAServices()
   var calculateViewPresentor = AfterCalculationViewPresenter()
   let plusSymbol = "+"
   //sut = system under test
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      try super.tearDownWithError()
    }

    
   
    
    //format for test function name
    
    //2)given
   
   //let assest = Asset
   
   
   
    //3)when
   
   
   func testResult_givenWinningAssetAndDCAIsUsed_expectPositiveGains(){
      let intialInvesmentAmount : Double = 5000
      let monthlyCostAveragingAmount: Double = 1500
      let initialDateOfInvestmentIndex : Int = 5
      let  asset = buildWinngAsset()
       //1) what given
      let result = sut.calculate(asset: asset , intialInvesmentAmount: intialInvesmentAmount, monthlyCostAveragingAmount: monthlyCostAveragingAmount , initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
      //when this funtion perform the asction 
      let calculateViewResult = calculateViewPresentor.getCalulaterViewpresentation(result: result)
      // calculate invetmentamount = 5000 += 5 * 1000 = 100
      
      // then
      XCTAssertEqual(result.InvestmentAmount, 12500.0, "This is incorrect")
      XCTAssertTrue(result.isProfitable)
      XCTAssertEqual(result.currentValue, 17342.224, accuracy : 0.1)
      XCTAssertEqual(result.gain, 4842.224, accuracy : 0.1)
      XCTAssertEqual(result.yield, 0.3873, accuracy : 0.0001 )
      
      XCTAssertEqual(calculateViewResult.currentValueLabelBackgroundColor, .themeGreen)
      XCTAssertEqual(calculateViewResult.yieldLabelTextColor, .systemGreen)
      XCTAssertEqual(calculateViewResult.currentValue, result.currentValue.currencyFormat)
      XCTAssertEqual( calculateViewResult.investmentAmount, result.InvestmentAmount.toCurrencyFormat(hasDecimalPlaces: false))
      XCTAssertEqual(calculateViewResult.gainLabel, 4842.224.toCurrencyFormat(hasDollarSymbol: false, hasDecimalPlaces: false))
      XCTAssertEqual(calculateViewResult.yieldLabelTextColor, .systemGreen)
      XCTAssertEqual(calculateViewResult.yieldLabel, result.yield.percentFormat.prefix(plusSymbol).addBracket())
      XCTAssertEqual(calculateViewResult.yieldLabelTextColor, .systemGreen)
     
      //jan 5000  5000/90 share 55.
      // feb 1000 1000/ 100
   
     // march 1000 / 110
      //april 1000/120
      //may 1000/130
      //june 1000/140
      }
   func testResult_givenWinningAssetAndDCAIsNotUsed_expectPositiveGains(){
      
      let intialInvesmentAmount : Double = 5000
      let monthlyCostAveragingAmount: Double = 0
      let initialDateOfInvestmentIndex : Int = 3
      let  asset = buildWinngAsset()
       //1) what
      let result = sut.calculate(asset: asset , intialInvesmentAmount: intialInvesmentAmount, monthlyCostAveragingAmount: monthlyCostAveragingAmount , initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
      // calculate invetmentamount = 5000 += 5 * 1000 = 100
      XCTAssertEqual(result.InvestmentAmount, 5000.0, "This is incorrect")
      XCTAssertTrue(result.isProfitable)
      XCTAssertEqual(result.currentValue, 6666.6666, accuracy : 0.1)
      XCTAssertEqual(result.gain, 1666.666, accuracy : 0.1)
      print(result.gain)
      XCTAssertEqual(result.yield, 0.3333, accuracy : 0.0001 )
      //jan 5000  5000/90 share 55.
      // feb 1000 1000/ 100
   
     // march 1000 / 110
      //april 1000/120
      //may 1000/130
      //june 1000/140
      
   }
   func testResult_givenWinningAssetAndDCAIsUsed_expectNegativeGains(){
      
      
      
   }
   func testResult_givenWinningAssetAndDCAIsNotUsed_expectNegativeGains(){
      
   }
   
   func buildWinngAsset()-> Asset{
      let searchResult = buildsearchSearchResult()
      let meta = buildMeta()
      let timeSeries : [String : OHLC] = [ "2021-1-20" : OHLC(open: "100", close: "110", adjustedClose: "110"), "2021-2-20" : OHLC(open: "110", close: "120", adjustedClose: "120"), "2021-3-20" : OHLC(open: "120", close: "130", adjustedClose: "130"), "2021-4-20" : OHLC(open: "130", close: "140", adjustedClose: "140"), "2021-5-20" : OHLC(open: "140", close: "150", adjustedClose: "150" ), "2021-6-20" : OHLC(open: "150", close: "160", adjustedClose: "160")
      ]
      let asset = Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: TimeSeriesMonthlyAdjusted(meta: meta, TimeSeries: timeSeries))
      return asset
   }
   
   func buildLosingAsset()-> Asset{
   let searchResult = buildsearchSearchResult()
   let meta = buildMeta()
   let timeSeries : [String : OHLC] = [ "2021-1-20" : OHLC(open: "100", close: "110", adjustedClose: "110"), "2021-2-20" : OHLC(open: "110", close: "120", adjustedClose: "120"), "2021-3-20" : OHLC(open: "120", close: "130", adjustedClose: "130"), "2021-4-20" : OHLC(open: "130", close: "140", adjustedClose: "140"), "2021-5-20" : OHLC(open: "140", close: "150", adjustedClose: "150" ), "2021-6-20" : OHLC(open: "150", close: "160", adjustedClose: "160")
   ]
   let asset = Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: TimeSeriesMonthlyAdjusted(meta: meta, TimeSeries: timeSeries))
   return asset
}
   func buildsearchSearchResult()-> SearchResult{
      return SearchResult(symbol: "XYZ", name: "XYZ Company", currency: "ETF", type: "USD")
      
   }
   func buildMeta()->Meta {
      return Meta(symbol: "XYZ")
   }
   
   
}

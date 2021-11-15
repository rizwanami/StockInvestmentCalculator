//
//  StocKInvesmentCalculatorTableViewController.swift
//  StockInvestCalculator
//
//  Created by Rizwana on 6/16/21.
//

import Foundation
import UIKit
import Combine
class StocKInvesmentCalculatorTableViewController : UITableViewController{
   // Mark :-   @IBOutlet
   @IBOutlet weak var currentValueLabel: UILabel!
   @IBOutlet weak var investmentAmountLabel: UILabel!
   @IBOutlet weak var gainLabel: UILabel!
   @IBOutlet weak var yieldLabel: UILabel!
   @IBOutlet weak var annualReturnLabel: UILabel!
   @IBOutlet weak var symbolLabel: UILabel!
   @IBOutlet weak var assetNameLabel: UILabel!
   @IBOutlet var currencyLabels: [UILabel]!
   @IBOutlet weak var investmentAmountCurrency: UILabel!
   @IBOutlet weak var intialInvesmentAmountTextfield: UITextField!
   @IBOutlet weak var monthlyCostAveragingTextfield: UITextField!
   @IBOutlet weak var initialDateOfInvestment: UITextField!
   @IBOutlet weak var dateSelectorSlider: UISlider!
   
   
   @Published private var initialDateOfInvestmentIndex : Int?
   @Published private var intialInvesmentAmount : Int?
   @Published private var monthlyCostAveragingAmount : Int?
   
   var asset : Asset?
   private var subscriber = Set<AnyCancellable>()
   private let dcaServices = DCAServices()
   private let calculateedViewPresenter = AfterCalculationViewPresenter()
   override func viewDidLoad() {
      super.viewDidLoad()
      setUpView()
      setUpTextfield()
      observedValueForInitialDateForInvestment()
      setupDateSlider()
      resetViews()
   }
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(true)
      intialInvesmentAmountTextfield.becomeFirstResponder()
      
   }
   @IBAction func SliderValueChange(_ sender : UISlider) {
      print("value of Slider", sender.value)
      initialDateOfInvestmentIndex = Int(sender.value)
      
   }
   func setUpView(){
      symbolLabel.text = asset?.searchResult.symbol
      assetNameLabel.text = asset?.searchResult.name
      investmentAmountCurrency.text  = asset?.searchResult.currency
      currencyLabels.forEach { (label) in
         label.text = asset?.searchResult.currency.addBracket()
         
      }
   }
   func setUpTextfield(){
      intialInvesmentAmountTextfield.donebutton()
      monthlyCostAveragingTextfield.donebutton()
      initialDateOfInvestment.delegate = self
   }
   func setupDateSlider(){
      if let count = asset?.timeSeriesMonthlyAdjusted.getMontInfo().count {
         let dateSliderCount = count - 1
         dateSelectorSlider.maximumValue = dateSliderCount.floatVlaue
         
      }
   }
   func resetViews(){
      currentValueLabel.text = "0.00"
      investmentAmountLabel.text = "0.00"
      gainLabel.text = "_"
      yieldLabel.text = "_"
      annualReturnLabel.text = "_"
   }
   func observedValueForInitialDateForInvestment(){
      $initialDateOfInvestmentIndex.sink { [unowned self](index) in
         print("$index",index)
         guard let index = index else{
            return}
         self.dateSelectorSlider.value = index.floatVlaue
         if let dateString = self.asset?.timeSeriesMonthlyAdjusted.getMontInfo()[index].month.MMYYFormat {
            self.initialDateOfInvestment.text = dateString
            print("monthlyCostAveragingAmount",$intialInvesmentAmount)
            
         }
         
      }.store(in: &subscriber)
      // 35 Observed field . we need to observed textfiled when user added value
      NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: intialInvesmentAmountTextfield).compactMap { (notification) -> String? in
         var text : String?
         if let textfield = notification.object as? UITextField {
            text = textfield.text
         }
         print("intialInvesmentAmountTextfield text",text)
         return text
      }
      
      .sink {[unowned self]
         (text) in
         self.intialInvesmentAmount = Int(text)
         //print("intialInvesmentAmount", intialInvesmentAmount)
      }
      .store(in: &subscriber)
      
      NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyCostAveragingTextfield).compactMap { (notification) -> String? in
         var text : String?
         if let textfield = notification.object as? UITextField {
            text = textfield.text
            print("monthlyCostAveragingTextfield", text)
         }
         return text
      }.sink{[unowned self]
         (text) in
      
         self.monthlyCostAveragingAmount = Int(text) ?? 0
         print(monthlyCostAveragingAmount)
      }
      .store(in: &subscriber)
      
      
      Publishers.CombineLatest3($intialInvesmentAmount, $monthlyCostAveragingAmount, $initialDateOfInvestmentIndex)
         .sink { (intialInvesmentAmount, monthlyCostAveragingAmoun, initialDateOfInvestmentIndex) in
            guard let intialInvesmentAmount = intialInvesmentAmount, let monthlyCostAveragingAmount = monthlyCostAveragingAmoun, let initialDateOfInvestmentIndex = initialDateOfInvestmentIndex else {return}
            if self.monthlyCostAveragingTextfield.text == "" {
               print("monthlyCostAveragingTextfield is empty" )
            }
            
            
            let result = self.dcaServices.calculate(asset: self.asset!, intialInvesmentAmount: intialInvesmentAmount.doubleValue, monthlyCostAveragingAmount: monthlyCostAveragingAmount.doubleValue, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex  )
            
            let calculatedView = self.calculateedViewPresenter.getCalulaterViewpresentation(result: result)
            
            
            self.currentValueLabel.backgroundColor = calculatedView.currentValueLabelBackgroundColor
            self.currentValueLabel.text = calculatedView.currentValue
            
            self.investmentAmountLabel.text = calculatedView.investmentAmount
            self.gainLabel.text = calculatedView.gainLabel
            self.yieldLabel.textColor = calculatedView.yieldLabelTextColor
            self.yieldLabel.text = calculatedView.yieldLabel
            self.annualReturnLabel.textColor = calculatedView.annualReturnLabelTextColor
            self.annualReturnLabel.text = calculatedView.annualReturn
            
            /*let isProfitable = result.isProfitable == true
             let plusSymbol = isProfitable ? "+" : ""
             self.currentValueLabel.backgroundColor = (result.isProfitable == true) ? .themeGreen : .themeRed
             self.currentValueLabel.text = result.currentValue.currencyFormat
             
             self.investmentAmountLabel.text = result.InvestmentAmount.toCurrencyFormat(hasDecimalPlaces: false)
             self.gainLabel.text = result.gain.toCurrencyFormat(hasDollarSymbol: false, hasDecimalPlaces: false)
             self.yieldLabel.textColor = isProfitable ? .systemGreen : .systemRed
             self.yieldLabel.text = result.yield.percentFormat.prefix(plusSymbol).addBracket()
             self.annualReturnLabel.textColor = isProfitable ? .systemGreen : .systemRed
             self.annualReturnLabel.text = result.returnValue.percentFormat
             */
            
            
            //            print("The amout is \(intialInvesmentAmount), \(monthlyCostAveragingAmoun), \(initialDateOfInvestmentIndex)")
         }
         .store(in: &subscriber)
      
   }
   
   
}

// showInitialDateSelection
//Mark:- Extesion UITextfieldDelegate

extension StocKInvesmentCalculatorTableViewController : UITextFieldDelegate {
   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      if textField == initialDateOfInvestment {
         performSegue(withIdentifier: "showInitialDateSelection", sender: asset)
         return false
      }
      // beacuse we dont want textfield to be editable intead make segue to another view
      return true
   }
   // Mark:- Prepare for segue
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showInitialDateSelection", let destination = segue.destination as? DateSelectionTableViewController , let asset = sender as? Asset {
         destination.timeSeriesMonthlyAdjusted = asset.timeSeriesMonthlyAdjusted
         destination.selectedDateIndex = initialDateOfInvestmentIndex
         print("destination.selectedDateIndex)", destination.selectedDateIndex)
         destination.didSelectDate = { [unowned self]
            index in print("index is \(index)")
            
            self.handleDateSeelction(index : index)
         }
         
         
      }
   }
   func handleDateSeelction(index : Int){
      self.initialDateOfInvestmentIndex = index
      print("index is ---", initialDateOfInvestmentIndex)
      
      guard navigationController?.visibleViewController is DateSelectionTableViewController else {
         return
      }
      navigationController?.popViewController(animated: true)
      if let monthinfos = asset?.timeSeriesMonthlyAdjusted.getMontInfo() {
         initialDateOfInvestment.text = monthinfos[index].month.MMYYFormat
      }
      
      
   }
}


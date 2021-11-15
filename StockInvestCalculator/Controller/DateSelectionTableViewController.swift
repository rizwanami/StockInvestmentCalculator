//
//  DateSelectionTableViewController.swift
//  StockInvestCalculator
//
//  Created by Rizwana on 6/17/21.
//

import UIKit
class DateSelectionTableViewController : UITableViewController{
   var monthsInfos : [MonthInfo]?
   var timeSeriesMonthlyAdjusted : TimeSeriesMonthlyAdjusted?
   var asset : Asset?
   var didSelectDate : ((Int)-> Void)?
   var selectedDateIndex : Int?
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUpMonthInfo()
      setupNavigation()
   }
   func setupNavigation(){
      title = "Select Date"
   }
   func setUpMonthInfo(){
      monthsInfos = timeSeriesMonthlyAdjusted?.getMontInfo() ?? []
    
   }
}
extension DateSelectionTableViewController {
   override func numberOfSections(in tableView: UITableView) -> Int {
      1
   }
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //print(monthsInfos?.count)
      
      return monthsInfos?.count ?? 0
   }
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! DateSelectionTableViewCell
      let index = indexPath.item
      if let monthsInfos = self.monthsInfos {
         let monthInfo = monthsInfos[indexPath.item]
         let isSelectedDateIndex = index == selectedDateIndex
         cell.configure(for : monthInfo, index: index, isSelecteDateIndex: isSelectedDateIndex)
      }
      
      return cell
   }
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      didSelectDate?(indexPath.item)
      tableView.deselectRow(at: indexPath, animated: true)
   }
}
class DateSelectionTableViewCell : UITableViewCell {
   @IBOutlet weak var dateLabel: UILabel!
   @IBOutlet weak var monthsAgoLabel: UILabel!
   func configure(for monthinfo : MonthInfo, index : Int, isSelecteDateIndex : Bool){
      
      dateLabel.text = monthinfo.month.MMYYFormat
      accessoryType = isSelecteDateIndex ? .checkmark : .none
      if index == 1 {
         monthsAgoLabel.text = "Invested 1 month ago"
      }else  if index > 1 {
         monthsAgoLabel.text = "Invested \(index) months ago"
      } else {
         monthsAgoLabel.text = "Invetsed just now"
      }
      
      
      
   }
  
}

//
//  ViewController.swift
//  StockInvestCalculator
//
//  Created by Rizwana on 6/8/21.
//

import UIKit
import Combine
import MBProgressHUD

class SearchTableViewController: UITableViewController, UISearchControllerDelegate {
   enum Mode {
      case onBoarding
      case search
   }
   private lazy var searchController : UISearchController = {
      let sc = UISearchController(searchResultsController : nil)
      sc.searchResultsUpdater = self
      sc.delegate = self
      //A Boolean indicating whether the underlying content is obscured during a search. a true va;ue will unclear the

      sc.obscuresBackgroundDuringPresentation = false
      sc.searchBar.placeholder = "Enter a company name or symbol"
      sc.searchBar.autocapitalizationType = .allCharacters
      
      return sc
   }()
   private var apiServices = APIServices()
   private var subscriber = Set<AnyCancellable>()
   @Published private var searchQuery = String()
   @Published private var mode : Mode = .onBoarding
   
   var searchResults : SearchResults?
   

   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
      setUpNavigationBar()
      //performSearch()
      observeForm()
      setupTableView()
      
   }
   func setupTableView(){
      tableView.tableFooterView = UIView()
      tableView.isScrollEnabled = false
   }

   func setUpNavigationBar(){
      navigationItem.searchController = searchController
      navigationItem.title = "Search"
   }
   func observeForm(){
      // This function update the searchQuery after 750 millisecond
      
      $searchQuery.debounce(for : .milliseconds(750), scheduler: RunLoop.main)
         .sink{
            [unowned self](searchQuery) in
           // print(searchQuery)
            guard !searchQuery.isEmpty else {
               return
            }
            showLodingAnimation()
            
            self.apiServices.fetchSearch(symbol : searchQuery)
               .sink(receiveCompletion: { completion in
                  hideLodingAnimation()
               switch completion {
               case .finished:
                   break
               case .failure(let error):
                   print(error.localizedDescription)
               }
           }, receiveValue: { searchResults in
            tableView.isScrollEnabled = true
            self.searchResults = searchResults
            
               //print(searchResults)
            self.tableView.reloadData()
            if searchController.searchBar.text == "" {
               var ser = [Any]()
               self.searchResults = ser as? SearchResults
               //print(searchResults)
            self.tableView.reloadData()
               
            }
            
            
           })
               .store(in : &self.subscriber)
         }
         .store(in : &subscriber)
     
      $mode.sink{[unowned self] (mode) in
         switch mode{
         case .onBoarding:
            
            self.tableView.backgroundView = SearchPlaceholderView()
            
         case .search:
            self.tableView.backgroundView = nil
            
         }
      }
      .store(in : &subscriber)
      
         
   }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return searchResults?.items.count ?? 0
   }
   // Provide a cell object for each row.
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // Fetch a cell of the appropriate type.
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchTableViewCell
      if let searchResults = self.searchResults {
         let searchResult = searchResults.items[indexPath.row]
         cell.configure(for: searchResult)
      }
      
      
      // Configure the cell’s contents.
      //cell.textLabel!.text = "Cell text"
          
      return cell
   }
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      if let searchResults = self.searchResults {
         let searchResut = searchResults.items[indexPath.row]
         let symbol = searchResults.items[indexPath.row].symbol
         //print(symbol)
         handleselection(for: symbol, searchResult: searchResut)
      }
      tableView.deselectRow(at : indexPath, animated: true)
      
   }
   func handleselection(for symbol : String, searchResult : SearchResult){
      showLodingAnimation()
      apiServices.fetchTimeSeriesMonthlyAdjusted(symbol : symbol)
         .sink { [unowned self] (completion) in
            self.hideLodingAnimation()
            switch completion {
            case .finished:
               break
            case .failure(let error):
               //print("this is error")
               print(error.localizedDescription)
               
            }
         } receiveValue: { [unowned self ](timeSeriesMonthlyAdjusted) in
            self.hideLodingAnimation()
           // print("The timeseries %%%%%(()))))))",timeSeriesMonthlyAdjusted.getMontInfo())
            let asset = Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
            self.performSegue(withIdentifier: "showCalculator", sender: asset)
         }
         .store(in: &subscriber)

     
   }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showCalculator", let destination = segue.destination as? StocKInvesmentCalculatorTableViewController , let asset = sender as? Asset {
         destination.asset = asset
      }
   }
   /* private func performSearch(){
      apiServices.fetchSearch(symbol : "Goo").sink(receiveCompletion: { completion in
         switch completion {
         case .finished:
             break
         case .failure(let error):
             print(error.localizedDescription)
         }
     }, receiveValue: { searchResults in
         print(searchResults)
     })
      .store(in : &subscriber)
         
   }
 */
   
}
// MARK: Extension

extension SearchTableViewController : UISearchResultsUpdating, UIAnimable{
   func updateSearchResults(for searchController: UISearchController) {
      guard let searchQuery = searchController.searchBar.text , !searchQuery.isEmpty else {
         return
      }
      
   
      self.searchQuery = searchQuery
      
   }
   func willPresentSearchController(_ searchController: UISearchController) {
      mode = .search
   }
   
}

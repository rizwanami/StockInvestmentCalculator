//
//  UIAnimable.swift
//  StockInvestCalculator
//
//  Created by Rizwana on 6/12/21.
//

import Foundation
import UIKit
import MBProgressHUD
protocol UIAnimable where Self : UIViewController {
   func showLodingAnimation()
   func hideLodingAnimation()
   }
extension UIAnimable {
   func showLodingAnimation(){
      DispatchQueue.main.async {
         
      
      MBProgressHUD.showAdded(to: self.view, animated: true)
      }
   }
   func hideLodingAnimation(){
      DispatchQueue.main.async {
         MBProgressHUD.hide(for: self.view, animated: true)
      }
   }
}

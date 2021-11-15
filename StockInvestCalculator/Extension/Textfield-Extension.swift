//
//  Textfield-Extension.swift
//  StockInvestCalculator
//
//  Created by Rizwana on 6/17/21.
//

import Foundation
import UIKit
extension UITextField {
   func donebutton(){
   let screenWidth = UIScreen.main.bounds.width
      let doneToolBar : UIToolbar = UIToolbar(frame: .init(x: 0, y: 0, width: screenWidth, height: 50))
      doneToolBar.barStyle = .default
      let flexspaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      let doneBarButtonItem = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(dismissedKeyboard))
      let items = [flexspaceBarButtonItem, doneBarButtonItem]
      doneToolBar.items = items
      doneToolBar.sizeToFit()
      inputAccessoryView = doneToolBar
      
   
   }
   @objc private func dismissedKeyboard(){
      resignFirstResponder()
   }
}

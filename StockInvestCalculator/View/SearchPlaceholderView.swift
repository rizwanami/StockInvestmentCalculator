//
//  SearchPlaceholderView.swift
//  StockInvestCalculator
//
//  Created by Rizwana on 6/10/21.
//

import Foundation
import UIKit
class SearchPlaceholderView : UIView {
   
   private var imageView : UIImageView = {
      let image = UIImage(named: "imDca")
      let imageView = UIImageView()
      imageView.image = image
      imageView.contentMode = .scaleAspectFit
      return imageView
   }()
   private var titleLabel : UILabel = {
      let label = UILabel()
      label.text = "Search for companies to calculate potential return via dollar cost averaging."
      label.font = UIFont(name: "AvenirNext-Medium", size: 14)
      label.textAlignment = .center
      label.numberOfLines = 0
      return label
      }()
   private lazy var stackview : UIStackView = {
      let stackview = UIStackView(arrangedSubviews:   [imageView, titleLabel])
      stackview.axis = .vertical
      stackview.spacing = 24
      stackview.translatesAutoresizingMaskIntoConstraints = false
      return stackview
   
   }()
   override init(frame : CGRect){
      super.init(frame: frame)
      setupView()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   private func setupView(){
      addSubview(stackview)
      NSLayoutConstraint.activate([stackview.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8), stackview.centerYAnchor.constraint(equalTo: centerYAnchor), stackview.centerXAnchor.constraint(equalTo: centerXAnchor), imageView.heightAnchor.constraint(equalToConstant: 88)
      ])
   }
}

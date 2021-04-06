//
//  CustomHeaderView.swift
//  Exchange
//
//  Created by Anton Kovalkov on 06.04.2021.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let backgroundView = UIView(frame: self.bounds)
        backgroundView.backgroundColor = .white
        self.backgroundView = backgroundView
    }
    

}

//
//  CurrencyLocale.swift
//  Exchange
//
//  Created by Anton Kovalkov on 06.04.2021.
//

import Foundation

class CurrencyLocale {
    
    //Locale date
    static func getLocaleDate(from str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: str) else { return str }
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MM yyyy")
        
        
        return dateFormatter.string(from: date)
    }
    
    
    //Locale value
    static func getLocaleValue(value: Float) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let nsValue = NSNumber(value: value)
        guard let strValue = numberFormatter.string(from: nsValue) else { return "" }
        return strValue
    }
}

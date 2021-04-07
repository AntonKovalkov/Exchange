//
//  DataModel.swift
//  Exchange
//
//  Created by Anton Kovalkov on 05.04.2021.
//

import Foundation


struct CurrencyDecodeData: Decodable {
    let base: String
    let date: String
    let rates: [String: Float]
    
    enum CodingKeys: String, CodingKey {
        case base
        case rates
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.base = try container.decode(String.self, forKey: .base)
        self.rates = try container.decode([String: Float].self, forKey: .rates)
        self.date = try container.decode(String.self, forKey: .date)
    }
}


struct CurrencyData {
    private let currencyDecodeData: CurrencyDecodeData
    var baseCurrency: String
    var date: String
    var currencyArray: [[String: String]] {
        get {
            return dataFilling(baseCurrency: baseCurrency)
        }
    }
    
    init(currencyDecodeData: CurrencyDecodeData) {
        self.currencyDecodeData = currencyDecodeData
        self.date = CurrencyLocale.getLocaleDate(from: currencyDecodeData.date)
        self.baseCurrency = currencyDecodeData.base
    }
    
    
    private func dataFilling(baseCurrency: String) -> [[String: String]] {
        guard let valueFromKey = currencyDecodeData.rates[baseCurrency] else {return [[:]] }
        let localeValue = CurrencyLocale.getLocaleValue(value: valueFromKey)
        let firstItem = [baseCurrency: localeValue]
        var rates = currencyDecodeData.rates
        rates[baseCurrency] = nil
        
        var arrayFromDict = rates.map {key, value in [key: CurrencyLocale.getLocaleValue(value: value)] }
        arrayFromDict.insert(firstItem, at: 0)
        
        return arrayFromDict
    }
    
}

//
//  DataModel.swift
//  Exchange
//
//  Created by Anton Kovalkov on 05.04.2021.
//

import Foundation


struct Currency: Decodable {
    private let currencyLocale = CurrencyLocale()
    var base: String
    var date: String
    private var rates: [String: Float]
    var currencyArray: [[String: String]] {
        get {
            return rates.map {key, value in [key: currencyLocale.getLocaleValue(value: value)] }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case base
        case rates
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.base = try container.decode(String.self, forKey: .base)
        self.rates = try container.decode([String: Float].self, forKey: .rates)
        let dateStr = try container.decode(String.self, forKey: .date)
        
        self.date = currencyLocale.getLocaleDate(from: dateStr)
    }
}

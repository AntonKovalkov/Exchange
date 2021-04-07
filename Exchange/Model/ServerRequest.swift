//
//  ServerRequest.swift
//  Exchange
//
//  Created by Anton Kovalkov on 05.04.2021.
//

import Foundation

class ServerRequest {
    
    static func getData(base: String = "EUR", complition: @escaping (CurrencyData?, NetworkError?) -> Void) {
        let baseURL = "http://api.exchangeratesapi.io/v1/latest"
        let accessKey = "b25b47adb4f5207d8a4e0c921754854e"
        
        guard let url = URL(string: "\(baseURL)?access_key=\(accessKey)&base=\(base)") else { complition(nil, .invalidURL); return }

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { complition(nil, .requestError); return}
            guard let data = data else {complition(nil, .requestError); return}
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 200
            if statusCode != 200 {
                complition(nil, .requestError)
                return
            }
            

            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(CurrencyDecodeData.self, from: data)

                complition(CurrencyData(currencyDecodeData: object), nil)
            } catch {
                complition(nil, .decodeError)
                return
            }
        }
        
        task.resume()
    }
}

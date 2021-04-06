//
//  ServerRequest.swift
//  Exchange
//
//  Created by Anton Kovalkov on 05.04.2021.
//

import Foundation

class ServerRequest {
    
    static func getData(base: String = "EUR", complition: @escaping (_ currency: Currency) -> Void) {
        let baseURL = "http://api.exchangeratesapi.io/v1/latest"
        let accessKey = "b25b47adb4f5207d8a4e0c921754854e"
        
        guard let url = URL(string: "\(baseURL)?access_key=\(accessKey)&base=\(base)") else { print("Invalid URL"); return }

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { print(error as Any); return}
            guard let data = data else {print("No data received"); return}
            
            
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(Currency.self, from: data)

                complition(object)
            } catch {
                print("Error with decode")
            }
        }
        
        task.resume()
    }
}

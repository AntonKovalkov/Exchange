//
//  NetworkError.swift
//  Exchange
//
//  Created by Anton Kovalkov on 06.04.2021.
//

import Foundation

enum NetworkError: String {
    case invalidURL = "Некорректный URL"
    case decodeError = "Ошибка получения данных"
    case requestError = "Ошибка запроса"
}

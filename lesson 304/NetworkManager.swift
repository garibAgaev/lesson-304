//
//  NetworkManager.swift
//  lesson 304
//
//  Created by Garib Agaev on 08.09.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    
    enum MyError: Error {
        case daysError
        case urlError
        case responseError
        case dataError
    }
    
    static let shared = NetworkManager()
    
    private let key = "4b17f00db3804d03965140234233108"
    private let baseURL = "https://api.weatherapi.com/v1"
    
    private init() {}
    
    func fetchLocations(q: String, comletion: @escaping(Result<[Location], AFError>) -> Void) {

        AF.request(baseURL + Request.searchOrAutocomplete.rawValue, method: .get, parameters: ["key": key, "q": q])
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    comletion(.success(Location.getLocations(for: value)))
                case .failure(let error):
                    comletion(.failure(error))
                }
            }
    }
    
    private func getParameters(request: Request, q: String, days: Int?) throws -> [String: String] {
        var parameters = ["key": key, "q": q]
        switch request {
        case .currentWeather, .searchOrAutocomplete:
            break
        case .forecast:
            guard let days = days, 0 < days && days <= 14 else {
                throw MyError.daysError
            }
            parameters["days"] = "\(days)"
        default:
            break
        }
        return parameters
    }
    
    private func generateURL(request: Request, q: String, days: Int?) throws -> URL {
        var urlComponents = URLComponents(string: baseURL + request.rawValue)
        urlComponents?.queryItems = try getParameters(request: request, q: q, days: days)
            .map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
        guard let url = urlComponents?.url else {
            throw MyError.urlError
        }
        return url
    }
    
    func fetchData<T: Decodable>(_ request: Request, q: String, days: Int?) async throws -> T {
        let url = try generateURL(request: request, q: q, days: days)
        let (data, response) = try await URLSession.shared.data(from: url)
        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
            throw MyError.responseError
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

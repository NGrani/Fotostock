//
//  NetworkGetRandom.swift
//  white and fluffy test
//
//  Created by Георгий Маркарян on 01.06.2022.
//

import Foundation

class NetworkGetImage {

    private func prepareParaments(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        
        parameters["query"] = searchTerm
        parameters["count"] = String(30)
        return parameters
    }

    private func url(params: [String: String]) -> URL{
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/random"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }

    private func prepareHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID TCteojlpjmf7S8utIyMAG1M_1EqTF2Juj7EEwYm3X_Y"
        return headers
    }

    private func createDataTask(from request: URLRequest, completion: @escaping (Data? , Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }

    func request(searchRequest: String, completion: @escaping (Data?, Error?) -> Void){
        let parameters = self.prepareParaments(searchTerm: searchRequest)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
}




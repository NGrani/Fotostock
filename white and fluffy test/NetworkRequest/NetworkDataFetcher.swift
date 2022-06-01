//
//  NetworkDataFetcher.swift
//  white and fluffy test
//
//  Created by Георгий Маркарян on 31.05.2022.
//

import Foundation

class NetworkDataFetcher {

    private var networkGetRandom = NetworkGetImage()

    func fetchImages(searchRequest: String, completion: @escaping ([ImagesResults]?) -> ()) {
        networkGetRandom.request(searchRequest: searchRequest) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }

            let decode = self.decodeJSON(type: [ImagesResults].self, from: data)
            completion(decode)
        }
    }

    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }

        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }

    func saveJson(fileName: String, model: [ImagesResults] ){
        if let filepath = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let data = try encoder.encode(model)
                let json = String(data: data, encoding: .utf8)
                try json!.write(toFile: filepath, atomically: false, encoding: .utf8)
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    func loadJson(filename fileName: String )->[ImagesResults]{
        var level: [ImagesResults]?
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([ImagesResults].self, from: data)
                level = jsonData

            } catch {
                print("error:\(error)")
            }
        }
        guard let level = level else { return [] }
        return level
    }
}

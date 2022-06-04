//
//  NetworkDataFetcher.swift
//  white and fluffy test
//
//  Created by Георгий Маркарян on 31.05.2022.
//

import Foundation

class LocalDataService {

    static let shared = LocalDataService()

    private init() {}

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

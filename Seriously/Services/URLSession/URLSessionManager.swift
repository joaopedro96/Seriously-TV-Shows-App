//
//  URLSessionManager.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 01/03/22.
//

import Foundation

class URLSessionManager {
    func execute<T: Decodable>(with urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  let data = data else { return }
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
//                print("\(data.prettyPrintedJSONString)\n\n")
                completion(.success(decodedData))
            } catch {
//                print(response)
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

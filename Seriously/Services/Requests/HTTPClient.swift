//
//  HTTPClient.swift
//  Seriously
//
//  Created by Joao Pedro da Mata Gonçalves Ribeiro on 01/03/22.
//

import Foundation

class URLSession {
        
    func execute<T: Decodable>(with urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else { return }
                
                guard let data = data else { return }
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    print(data.prettyPrintedJSONString)
                    completion(.success(decodedData))
                    
                } catch {
                    print(response)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
}

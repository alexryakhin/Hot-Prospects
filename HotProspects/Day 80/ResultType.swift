//
//  ResultType.swift
//  HotProspects
//
//  Created by Alexander Bonney on 6/25/21.
//

import SwiftUI

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}

struct ResultType: View {
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                fetchData(from: "https://www.apple.com") { result in
                    switch result {
                    
                    case .success(let str):
                        print(str)
                    case .failure(let error):
                        switch error {
                        case .badURL:
                            print("Bad URL")
                        case .requestFailed:
                            print("Request failed")
                        case .unknown:
                            print("Unknown")
                        }
                    }
                }
            }
    }
    
    func fetchData(from urlString: String, completed: @escaping (Result<String, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completed(.failure(.badURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    let stringData = String(decoding: data, as: UTF8.self)
                    completed(.success(stringData))
                } else if error != nil {
                    completed(.failure(.requestFailed))
                } else {
                    completed(.failure(.unknown))
                }
            }
        }.resume()
    }
}

struct ResultType_Previews: PreviewProvider {
    static var previews: some View {
        ResultType()
    }
}

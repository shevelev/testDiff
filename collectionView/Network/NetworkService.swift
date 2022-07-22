//
//  NetworkService.swift
//  collectionView
//
//  Created by Сергей Шевелев on 22.07.2022.
//

import UIKit

class NetworkService {
    static let shared = NetworkService()
    
    private let urlString = "https://itunes.apple.com/search?term=sia&entity=album&attribute=albumTerm"
    
    func downloadContactsFromServer(completion: @escaping (Bool,[TestObject]) -> Void ) {
        var datas = [TestObject]()
        print("---------------------------------")
        print("Attempting to download ..........")
        print("---------------------------------")
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("---------------------------------")
                print("Failed to download:",err)
                print("---------------------------------")
                completion(false,[])
                return
            }
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            
            do {
                let jsonTests = try jsonDecoder.decode(FetchData.self, from: data)
                jsonTests.results.forEach({ (json) in
                    datas.append(json)

                })
            } catch let jsonDecodeErr {
                print("-------------------------------------------")
                print("Failed to decode with error:", jsonDecodeErr)
                print("-------------------------------------------")
                completion(false,[])
            }
            print("-----------------------")
            print("Finished downloading...")
            print("-----------------------")
            completion(true,datas)
        }.resume()
    }
}

//
//  FetchData.swift
//  collectionView
//
//  Created by Сергей Шевелев on 22.07.2022.
//

import Foundation

struct FetchData: Decodable {
    var resultCount: Int
    var results: [TestObject]
}

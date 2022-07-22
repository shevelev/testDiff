//
//  TestObject.swift
//  collectionView
//
//  Created by Сергей Шевелев on 22.07.2022.
//

import Foundation

struct TestObject: Decodable, Hashable {
    let artistName: String
    let collectionName: String
    let trackCount: Int
    
    private enum CodingKeys : String, CodingKey { case artistName, collectionName, trackCount }

    var uuid = UUID()
    
    static func ==(lhs: TestObject, rhs: TestObject) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

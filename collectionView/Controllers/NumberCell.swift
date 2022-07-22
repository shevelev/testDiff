//
//  NumberCell.swift
//  collectionView
//
//  Created by Сергей Шевелев on 19.07.2022.
//

import UIKit

class NumberCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: NumberCell.self)
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    var test: TestObject? {
       didSet {
           label.text = test?.artistName
           label2.text = test?.collectionName
       }
    }
}

//
//  Item.swift
//  Shopicruit-Sum
//
//  Created by Miwand Najafe on 2016-09-20.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import UIKit

// Mark: Item Structure in case I wanted more information than just the price or even individual prices
struct Item {
    let productName: String
    let productType: String
    let priceFromVariant: [Double]
    var priceDouble: Double {
        return self.priceFromVariant.reduce(0, +)
    }
}

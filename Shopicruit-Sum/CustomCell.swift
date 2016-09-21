//
//  CustomCell.swift
//  Shopicruit-Sum
//
//  Created by Miwand Najafe on 2016-09-20.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var productTotalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configCell(item: Item) {
        productNameLabel.text = "Product Name: " + item.productName
        productTypeLabel.text = "Product Type: " + item.productType
        productTotalPrice.text = "Total Price of all Variants: $ \(item.priceDouble)"
    }
    
}

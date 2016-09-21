//
//  APIClient.swift
//  Shopicruit-Sum
//
//  Created by Miwand Najafe on 2016-09-20.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import UIKit

// Mark: Client for getting data from url and return data as an array of Item
class APIClient {
    var totalPrice: Double = 0.0
    static let sharedInstance = APIClient()
    private var items = [Item]()
    private init() {}
    
    func getData(productFilter: [String], start: Int, end: Int, urlName:String, completion: @escaping ([Item], Double) -> ()) -> () {
        for i in start...end {
            guard let url = URL(string: urlName + "\(i)") else { print("Could not get url from string")
                return
            }
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    guard let data = data else { print("Could not get data"); return }
                    do {
                        guard let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, AnyObject> else {
                            print("Could not convert Data to json"); return }
                        
                        guard let productDict = jsonDict["products"] as? [Dictionary<String,AnyObject>] else { return }
                        
                        for p in productDict {
                            guard let productName = p["title"] as? String else {
                                print("Could not get product Name from Json")
                                return
                            }
                            guard let productType = p["product_type"] as? String else {
                                print("Could not get product type from Json")
                                return
                            }
                            if productFilter.contains(productType) {
                                guard let variants = p["variants"] as? [Dictionary<String, AnyObject>] else { print("Could not get the different Variants"); return }
                                var priceFromVariant = [Double]()
                                
                                for v in variants {
                                    guard let price = v["price"] as? String else { print("Could not get the price from variants"); return }
                                    let newPrice = (Double(price)!)
                                    priceFromVariant.append(newPrice)
                                }
                                let newItem = Item(productName: productName, productType: productType, priceFromVariant: priceFromVariant)
                                self.totalPrice += newItem.priceDouble
                                self.items.append(newItem)
                            }
                            if self.items.count == end + 1 {
                                completion(self.items, self.totalPrice)
                            }
                            
                        }
                    } catch let err {
                        print("Caught Error during Json Serialization: ", err.localizedDescription)
                    }
                } else {
                    print("Error: ", error.debugDescription)
                }
                }.resume()
        }
    }
}

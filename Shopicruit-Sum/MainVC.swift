//
//  MainVC.swift
//  Shopicruit-Sum
//
//  Created by Miwand Najafe on 2016-09-20.
//  Copyright © 2016 Miwand Najafe. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    var itemz = [Item]()
    var productFilterString = ""
    var sum = 0.0
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var filterTextfield: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    // Mark: Gather all the data and once the end of the page is reached get the final sum of all the product that you are looking for.
    func getItemsAndSum(productFilter: [String] ,start: Int, end: Int, urlName: String, completion: @escaping ([Item], Double) -> ()) -> ()  {
        APIClient.sharedInstance.getData(productFilter: productFilter, start: start, end: end, urlName: urlName) { (items, price) in
            completion(items, price)
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.totalLabel.text = "Total sum of all \(self.productFilterString) is \(self.sum)"
            self.mainTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        let productFilter = ["Watch","Clock"]
        getItemsAndSum(productFilter: productFilter, start: Constants.START_AT_PAGE, end: Constants.NUMBER_OF_PAGES, urlName: Constants.SHOPICRUIT_URL_STRING) { (items, sum) in
            self.itemz = items
            self.sum = sum
            self.reloadTableView()
        }
    }
    
    func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func getNewItemsAction(sender: UIButton) {
        guard let prodFilt = filterTextfield.text else { presentAlertView("Error!", "Need to enter a value in the textfield"); return }
        let productFilter = prodFilt.replacingOccurrences(of: " ", with: ",").components(separatedBy: ",")
        getItemsAndSum(productFilter: productFilter, start: Constants.START_AT_PAGE, end: Constants.NUMBER_OF_PAGES, urlName: Constants.SHOPICRUIT_URL_STRING) { (items, sum) in
            self.itemz = items
            self.reloadTableView()
        }
    }
    
    func presentAlertView(_ title: String, _ message: String) {
        let alertControlla = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertControlla.addAction(okAction)
        present(alertControlla, animated: true, completion: nil)
    }
}

// Mark: Tableview methods
extension MainVC: UITableViewDelegate {
    
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemz.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.MAIN_CELL, for: indexPath) as? CustomCell {
            let item = itemz[indexPath.row]
            cell.configCell(item: item)
            return cell
        }
        return UITableViewCell()
    }
}

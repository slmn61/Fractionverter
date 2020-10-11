//
//  ViewController.swift
//  Fractionverter
//
//  Created by selman birinci on 10/5/20.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var fractionList: [FractionList] = [FractionList(fr: "1/4"),
                                        FractionList(fr: "1/2"),
                                        FractionList(fr: "3/4"),
                                        FractionList(fr: "1/1")]
    
    
    //var fractionList: [[String: Double]] = [["1/4": 0.250], ["1/2": 0.500], ["3/4": 0.750], ["1": 1.000]]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }

    @IBAction func addNewFraction(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Fraction Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Fraction", style: .default) { (action) in
                    //what will happen once the user clicks the Add Item button on our UIAlert
                    
            let newFraction = textField.text!
            let fr = FractionList(fr: newFraction)
            
            
            
            self.fractionList.append(fr)
                
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Create new item"
                    textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fractionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fraction = fractionList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! Cell
        cell.fraction.text = fraction.fraction
        cell.decimal.text = fraction.decimal
        return cell
    }
    
}


//
//  ViewController.swift
//  Fractionverter
//
//  Created by selman birinci on 10/5/20.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var fractionList: [FractionList] = [FractionList(fr: "1/4", dc: 0.250),
                                        FractionList(fr: "1/2", dc: 0.500),
                                        FractionList(fr: "3/4", dc: 0.750),
                                        FractionList(fr: "1", dc: 1.000)]
    
    
    //var fractionList: [[String: Double]] = [["1/4": 0.250], ["1/2": 0.500], ["3/4": 0.750], ["1": 1.000]]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }

    @IBAction func addNewFraction(_ sender: UIBarButtonItem) {
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fractionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fraction = fractionList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! Cell
        cell.fraction.text = fraction.fraction
        cell.decimal.text = String(fraction.decimal)
        return cell
    }
    
}


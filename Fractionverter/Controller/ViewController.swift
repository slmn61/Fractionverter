//
//  ViewController.swift
//  Fractionverter
//
//  Created by selman birinci on 10/5/20.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   
    var fractionList = [Fractions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        loadFractions()
    }
    
    @IBAction func addNewFraction(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Fraction Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Fraction", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            //let newFraction = textField.text!
            //let fr = FractionList(fr: newFraction)
            let fr = Fractions(context: self.context)
            fr.fraction = textField.text!
            
            self.fractionList.append(fr)
            
            self.saveFractions()
            
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
        let fr = fractionList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! Cell
        cell.fraction.text = fr.fraction
        cell.decimal.text = converter(fr: fr.fraction!)
        return cell
    }
    
    
    func saveFractions() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadFractions() {
        
        let request : NSFetchRequest<Fractions> = Fractions.fetchRequest()
        
        do{
            fractionList = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
       
        tableView.reloadData()
        
    }
    
    func converter (fr fraction: String) -> String{
        
        let index = fraction.firstIndex(of: "/") ?? fraction.endIndex
        let last = fraction.index(after: index)

        
        
        let up = Double(fraction[..<index]) ?? 1.0
        let down = Double(fraction[last...]) ?? 2.0
        
        let val: Double = up/down
        
        let decimal = String(format: "%.4f", val)
        return decimal
    }
    
}


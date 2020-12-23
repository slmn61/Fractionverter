//
//  ViewController.swift
//  Fractionverter
//
//  Created by selman birinci on 10/5/20.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework

class ViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tempColor = FlatBlueDark()
    
    
    var fractionList = [Fractions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(hexString: "5A5A5A")

        
        loadFractions()
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 80.0
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fractionList.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fr = fractionList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FrictionCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        let completeLine: String = fr.fraction! + "         " + fr.decimal!
        
        
        cell.textLabel?.text = completeLine
        
        cell.backgroundColor = UIColor(hexString: fr.color ?? "#FFFFFF")
        
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
    
    func deleteFtactions(fr: NSManagedObject){
        
        context.delete(fr)
        
        //tableView.reloadData()
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
    
    
    @IBAction func addNewFraction(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Fraction Item", message: "", preferredStyle: .alert
    )
        
        
        let action = UIAlertAction(title: "Add Fraction", style: .default) { (action) in
            
            let fr = Fractions(context: self.context)
            if let frText = textField.text{
                fr.fraction = frText
                fr.decimal = self.converter(fr: frText)
                fr.color = self.tempColor.hexValue()
                self.tempColor = self.tempColor.lighten(byPercentage: CGFloat(0.05))!
                self.fractionList.append(fr)
                
                self.saveFractions()
            }
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
   
    
}

//MARK: - SwipeCellDelegate methods
extension ViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            let fr = self.fractionList[indexPath.row]
            self.fractionList.remove(at: indexPath.row)
            self.deleteFtactions(fr: fr)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
    
}


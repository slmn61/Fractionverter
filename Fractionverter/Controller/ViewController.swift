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
    
    
    let divideLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
   
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tempColor = FlatBlueDark()
    
    
    var fractionList = [Fractions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(hexString: "5A5A5A")

        divideLabel.text = "/"
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
        
        
        
        let l1 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        l1.text = fr.fraction
        l1.textAlignment = .center
        
        
        let l2 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        l2.text = fr.decimal
        l2.textAlignment = .center
        
        
        let stkView = UIStackView()
        
        stkView.addSubview(l1)
        stkView.addSubview(l2)
        
//        let bottom = NSLayoutConstraint(item: stkView, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1.0, constant: 5)
//        
//        let top = NSLayoutConstraint(item: stkView, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: 5)
//        
//        let left = NSLayoutConstraint(item: stkView, attribute: .left, relatedBy: .equal, toItem: cell, attribute: .left, multiplier: 1.0, constant: 5)
//        
//        let right = NSLayoutConstraint(item: stkView, attribute: .right, relatedBy: .equal, toItem: cell, attribute: .right, multiplier: 1.0, constant: 5)

        
        stkView.axis = .horizontal
        
        
        stkView.distribution = .fillEqually
        stkView.alignment = .fill
        stkView.spacing = 5
        
        cell.addSubview(stkView)
        //cell.addSubview(l2)
        
//        stkView.addConstraint(bottom)
//        stkView.addConstraint(top)
//        stkView.addConstraint(left)
//        stkView.addConstraint(right)
        
        
        //cell.textLabel?.text = completeLine
        
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
    
    func converter (nume: String, denome: String) -> String{
        let up = Double(nume) ?? 0.0
        let down = Double(denome) ?? 1.0
        
        let val = up/down

        let decimal = String(format: "%.4f", val)
        
        return decimal
    }
    
    
    var alert: UIAlertController!

    func notifyUser() -> Void
    {
        let alert = UIAlertController(title: "MESSAGE", message: "Please Add Fraction!!!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")

                case .cancel:
                    print("cancel")

                case .destructive:
                    print("destructive")

                @unknown default:
                    fatalError()
                }}))
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                alert.dismiss(animated: true, completion: nil)
            }
    }
    
    
    @IBAction func addNewFraction(_ sender: UIBarButtonItem) {
        
        var numeratorTextField = UITextField()
        numeratorTextField.keyboardType = .numberPad
        
        var denominatorTextField = UITextField()
        denominatorTextField.keyboardType = .numberPad
        
        let alert = UIAlertController(title: "Add New Fraction Item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Fraction", style: .default) { (action) in
           
            
            let fr = Fractions(context: self.context)
            
            guard let text = numeratorTextField.text, !text.isEmpty else {
                self.notifyUser()
                return
            }
            
            guard let text2 = denominatorTextField.text, !text2.isEmpty else {
                self.notifyUser()
                return
            }
            
            
            if let frNumeratorText = numeratorTextField.text, let frDenominatorText = denominatorTextField.text {
                    fr.fraction = frNumeratorText + "/" + frDenominatorText
                    fr.decimal = self.converter(nume: frNumeratorText, denome: frDenominatorText)
                    fr.color = self.tempColor.hexValue()
                    self.tempColor = self.tempColor.lighten(byPercentage: CGFloat(0.05))!
                    self.fractionList.append(fr)
                    
                    self.saveFractions()
            }
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Numerator"
            alertTextField.keyboardType = .numberPad
            numeratorTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Denominator"
            alertTextField.keyboardType = .numberPad
            denominatorTextField = alertTextField
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


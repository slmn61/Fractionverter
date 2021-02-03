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
    
    
    //let divideLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
   
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var fractionList = [Fractions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(hexString: "5A5A5A")

        //divideLabel.text = "/"
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
        
        let l1 = UILabel(frame: CGRect(x: 10, y: 25, width: 100, height: 21))
        let l2 = UILabel(frame: CGRect(x: 250, y: 25, width: 100, height: 21))
        
        
        l1.text = fr.fraction
        l2.text = fr.decimal
        
        
        l1.textAlignment = .center
        l2.textAlignment = .center
        
        cell.addSubview(l1)
        cell.addSubview(l2)
        
        cell.backgroundColor = UIColor(hexString: fr.color ?? "#FFFFFF")
        
        return cell
    }


    func saveFractions() {
        do {
            try context.save()
        } catch {
            print("Error saving fractions \(error)")
        }
        
        //tableView.reloadData()
        loadFractions()
        
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
                    fr.color = RandomFlatColor().hexValue()
            }
            self.fractionList.append(fr)
            self.saveFractions()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Numerator"
            alertTextField.keyboardType = .numberPad
            alertTextField.delegate = self
            numeratorTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Denominator"
            alertTextField.keyboardType = .numberPad
            alertTextField.delegate = self
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
            self.context.delete(fr)
            self.fractionList.remove(at: indexPath.row)
        }
                
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}

extension ViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 2
        }
}

//
//  ViewController.swift
//  ToDoey
//
//  Created by Ben Weinberg on 2017-12-18.
//  Copyright © 2017 Ben Weinberg. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var cellModels = [CellData]()
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let newItemOne = CellData()
        newItemOne.title = "Wazy"
        cellModels.append(newItemOne)

        let newItemTwo = CellData()
        newItemTwo.title = "Belz"
        cellModels.append(newItemTwo)
        
        let newItemThree = CellData()
        newItemThree.title = "Petruska"
        cellModels.append(newItemThree)
        
        //grabbing the code we've saved into user defaults
        if let items = defaults.array(forKey: "TodoListArray") as? [CellData] {
            cellModels = items
        }
        
    }
    
    //DATA SOURCE METHODS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = cellModels[indexPath.row].title
        
        // Ternary Operator:
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = cellModels[indexPath.row].done ? .checkmark : .none
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if true become false.
        //If false become true
        //(cleaner code than if else)
        self.cellModels[indexPath.row].done = !self.cellModels[indexPath.row].done
        
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCell = CellData()
            newCell.title = textField.text!
            
            self.cellModels.append(newCell)
            
            
            //the key identifies the array inside our user defaults
            //you need the key for the plist (where user default is saved)
//            self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = ""
            textField = alertTextfield
        }
      
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


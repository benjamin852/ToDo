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
    
    
    let userDefault = UserDefaults.standard
    
    //code gets stored and retrieved form this plist file
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print (dataFilePath ?? "wazy")
        loadCells()
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
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCell = CellData()
            newCell.title = textField.text!
            
            self.cellModels.append(newCell)
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = ""
            textField = alertTextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems()  {
        //the key identifies the array inside our user defaults
        //you need the key for the plist (where user default is saved)
        //self.defaults.setValue(self.cellModels, forKey: "TodoListArray")
        
        let encoder = PropertyListEncoder()
        do {
            //encode the data in the cellModel array
            let data = try encoder.encode(cellModels)
            try data.write(to: dataFilePath!)
        } catch {
            print (error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    func loadCells()  {
        if let data = try? Data(contentsOf: self.dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                self.cellModels = try decoder.decode([CellData].self, from: data)
            } catch {
                print (error.localizedDescription)
            }
        }
    }
    
}


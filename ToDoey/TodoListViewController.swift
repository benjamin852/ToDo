//
//  ViewController.swift
//  ToDoey
//
//  Created by Ben Weinberg on 2017-12-18.
//  Copyright © 2017 Ben Weinberg. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Egos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //DATA SOURCE METHODS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    
    //Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    //Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
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


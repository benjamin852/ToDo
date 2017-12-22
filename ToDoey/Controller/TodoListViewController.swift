//
//  ViewController.swift
//  ToDoey
//
//  Created by Ben Weinberg on 2017-12-18.
//  Copyright © 2017 Ben Weinberg. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var cellModels = [Item]()
    var selectedCategory : Category? {
        //this stuff happens as soon as selectedCategory gets set with a value
        didSet {
            loadItems()
        }
    }
    
    //UIApplication.shared() = a singleton of when the app is running live for the user
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
            
            let coreDataItem = Item(context: self.moc)
            coreDataItem.title = textField.text!
            coreDataItem.done = false
            
            //the parent item is the item we segued from as indicated by the selected category var
            coreDataItem.parentCategory = self.selectedCategory
            
            self.cellModels.append(coreDataItem)
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
        do {
            //we need moc.save() to transfer data from temporary context to permanent container
            try moc.save()
        } catch {
            print (error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    //we have a default value for the fetchRequest parameter so we can call func without paramters
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        //makes sure we filter and keep the items where the parent category matches the selected cateogry
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let unwrappedCompoundPredicate = predicate {
            request.predicate =  NSCompoundPredicate(andPredicateWithSubpredicates: [unwrappedCompoundPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do  {
            cellModels = try moc.fetch(request)
        } catch {
            print (error.localizedDescription)
        }
        tableView.reloadData()
    }
}

//Search Bar Functionality:
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)//searchBar.text! is passed into %@
        
        //the order in which we want our data returned
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //search must contain the title
        loadItems(with: request, predicate: predicate)
        tableView.reloadData()
    }
    
    
    //every letter you type triggers this method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //Dispatch Queue = assigns projects to different threads
            //Main Thread = Where you update the UI
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


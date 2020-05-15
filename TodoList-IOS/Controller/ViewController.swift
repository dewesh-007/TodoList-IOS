//
//  ViewController.swift
//  TodoList-IOS
//
//  Created by Dewesh Sunuwar on 13/5/20.
//  Copyright © 2020 Dewesh Sunuwar. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var manageObjectContext: NSManagedObjectContext!
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemList")
        let check = itemArray[indexPath.row]
        cell.textLabel?.text = check.title
        
        cell.accessoryType = check.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add ToDo list items", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let items = Item(context: self.manageObjectContext)
            items.title = textField.text!
            items.done = false
            items.parentCategory = self.selectedCategory
            self.itemArray.append(items)
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        do {
            try manageObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), and predicate: NSPredicate? = nil) {
        
        if let selectedName = selectedCategory!.name {
            let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedName)
                    
            if let additionalPredicate = predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            } else {
                request.predicate = categoryPredicate
            }
            
            do {
                itemArray = try manageObjectContext.fetch(request)
            } catch {
                print(error.localizedDescription)
            }
            tableView.reloadData()
        }
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, and: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

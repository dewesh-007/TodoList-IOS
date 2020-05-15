//
//  ViewController.swift
//  TodoList-IOS
//
//  Created by Dewesh Sunuwar on 13/5/20.
//  Copyright © 2020 Dewesh Sunuwar. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemList")
        if let check = todoItems?[indexPath.row] {
            cell.textLabel?.text = check.title
            cell.accessoryType = check.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No item Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let items = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    items.done = !items.done
                }
            } catch {
                print(error.localizedDescription)
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add ToDo list items", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add items", style: .default, handler: { (alert) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            self.tableView.reloadData()
        }))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter items here"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
}

extension ViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

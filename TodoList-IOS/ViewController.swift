//
//  ViewController.swift
//  TodoList-IOS
//
//  Created by Dewesh Sunuwar on 13/5/20.
//  Copyright © 2020 Dewesh Sunuwar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [
        "Here is item one to do",
        "here is item two to do",
        "here is item three to do"
    ]
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoItem") as? [String] {
            itemArray = items
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemList")
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add ToDo list items", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            //What to do when add item is pressed
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "TodoItem")
            self.tableView.reloadData()
        }))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
}


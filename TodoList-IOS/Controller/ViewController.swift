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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //loadItems()
        
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
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action) in            
            
            
            let items = Item(context: self.manageObjectContext)
            items.title = textField.text!
            items.done = false
            self.itemArray.append(items)
            self.saveItems()
        }))
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        do {
            try manageObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
        self.tableView.reloadData()
    }
    
    //    func loadItems() {
    //        if let data = try? Data(contentsOf: dataFilePath!) {
    //            let decoder = PropertyListDecoder()
    //            do {
    //                itemArray = try decoder.decode([Item].self, from: data)
    //            } catch {
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }
    
}


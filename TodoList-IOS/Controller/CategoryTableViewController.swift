//
//  CategoryTableViewController.swift
//  TodoList-IOS
//
//  Created by Dewesh Sunuwar on 15/5/20.
//  Copyright © 2020 Dewesh Sunuwar. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext!
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        loadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //saveData()
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create Categories", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (alert) in
            
            let category = Category(context: self.managedObjectContext)
            category.name = textField.text!
            self.categoryArray.append(category)
            self.saveData()
        }))
        alert.addTextField { (newTextField) in
            newTextField.placeholder = "Add Category"
            textField = newTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func loadData () {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
           categoryArray = try managedObjectContext.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
}

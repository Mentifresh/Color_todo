//
//  ViewController.swift
//  Color Todo
//
//  Created by Daniel Kilders Díaz on 28/11/2018.
//  Copyright © 2018 dankil. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    // Current app instance singleton
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        loadItems()
    }

    // MARK: - Tableview datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        itemArray[indexPath.row].done ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        
        return cell
    }
    
    // MARK: - Tableview delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentCell = tableView.cellForRow(at: indexPath)
        
        // Invert accesoryType
        itemArray[indexPath.row].done ? (currentCell?.accessoryType = .none) : (currentCell?.accessoryType = .checkmark)
        // Invert value
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item to the list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            // Add new row to tableview with new item
            self.tableView.insertRows(at: [IndexPath(row: self.itemArray.count - 1, section: 0)], with: .automatic)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func saveItems() {
//        let encoder = PropertyListEncoder()
        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    private func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}


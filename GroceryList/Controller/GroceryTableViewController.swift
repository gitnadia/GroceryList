//
//  GroceryTableViewController.swift
//  GroceryList
//
//  Created by nadezda.gura
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController {
    
    //var groceries = [String]()
    var groceries = [Grocery]()
    var manageObjectContext:NSManagedObjectContext?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        manageObjectContext = appDelegate.persistentContainer.viewContext
        
        
        loadData()
       }
    
    func loadData(){
        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        do {
            let result = try manageObjectContext?.fetch(request)
            groceries = result!
            tableView.reloadData()
            
        }catch{
            fatalError("Error in retrieving Grocery Items")
        }
    }
    
    
    func saveData(){
        do{
            try manageObjectContext?.save()
            
        }catch{
            fatalError("Error in saving Grocery Item")
            
        }
        loadData()
        
    }
    @IBAction func addNewItem(_ sender: Any) {
        
        let alertController = UIAlertController(title: "NEW GROCERY ITEM", message: "What would you like to add?", preferredStyle: .alert)
        alertController.addTextField { textField in
            print(textField)
        }
        let addActionButton = UIAlertAction(title: "ADD", style: .default) { alertAction in
            let textField = alertController.textFields?.first
            let entity = NSEntityDescription.entity(forEntityName: "Grocery", in: self.manageObjectContext!)
            let grocery = NSManagedObject(entity: entity!, insertInto: self.manageObjectContext)
            
            grocery.setValue(textField?.text, forKey: "item")
            self.saveData()
            
            //self.groceries.append((textField?.text)!)
           // self.tableView.reloadData()
            
            
        } //add action
        
        let cancelButton = UIAlertAction(title: "CANCEL", style: .destructive, handler: nil)
        
        alertController.addAction(addActionButton)
        alertController.addAction(cancelButton)
        
        
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    // MARK: - Table view delegate
    
    //show the count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groceries.count
    }

   //present items
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)

        //cell.textLabel?.text = groceries[indexPath.row]
        let grocery = groceries[indexPath.row]
        cell.textLabel?.text = grocery.value(forKey: "item") as? String
        cell.accessoryType = grocery.completed ? .checkmark : .none

        return cell
    }
   



  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            manageObjectContext?.delete(groceries[indexPath.row])
        }
        self.saveData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        groceries[indexPath.row].completed = !groceries[indexPath.row].completed
        self.saveData()
    }
    

}

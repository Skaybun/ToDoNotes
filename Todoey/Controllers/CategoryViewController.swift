//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ali KINU on 27.03.2023.

//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    var categories : Results <Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        loadCategories()
    }
    override func viewWillAppear(_ animated: Bool) {
            guard let navBar = navigationController?.navigationBar else { fatalError("NavCler does not exist") }
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
        }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) //ORDA URETILEN INDEXpATH BURAYA DA GECIO
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.colour) else {fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
      else { print("No category added yet") }
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6")
        
        return cell
    }
    
    //MARK: - Checkmark Settings - SEGUE WAY
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated:true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //LOCAL VARIABLE
        var textField = UITextField()
        let newCategory = Category()

        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
        }
        
            self.saveCategories(category : newCategory)
        
        alert.addTextField() { (alertTextField) in
            alertTextField.placeholder = "add an item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    //MARK: - Data Manipulation Methods--- SAVE, LOAD AND DELETE
    func saveCategories(category: Category){
        
        do{
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("realmEEEEEEEEEEEE \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func loadCategories(){
        
        categories = realm.objects(Category.self) //!!
        
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] { 
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("realmEEEEEEEEEEEE \(error)")
            }
            
            
        }
    }
    
}




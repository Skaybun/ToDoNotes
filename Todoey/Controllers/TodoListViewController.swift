//
//  ViewController.swift
//  Todoey
//
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet var searchBar: UITableView!
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.colour {
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {fatalError("NavCler does not exist")}
            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.backgroundColor = navBarColor
                searchBar.tintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
            }
            
        } else {
            
        }
    }
    //MARK: - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {    //--->> tableView.reloadData()  <<-----
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            if let colour = UIColor(hexString:selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "no Item added"
            
            
        }
        return cell
        
    }
    
    //MARK: - Checkmark Settings
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
            
        tableView.deselectRow(at:indexPath, animated:true)

    }
    //MARK: - Add and Save new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()  

        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch{
                    print("ERRRRRRRRROR SAVİNG ITEMMMM\(error)")
                }
                
            }
            self.tableView.reloadData()
            
        }
        
        
        alert.addTextField() { (alertTextField) in
            alertTextField.placeholder = "add an item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    //MARK: - Model Manuplation Method LOAD AND DELETE
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title")
        
        tableView.reloadData()
        
    }
    override func updateModel(at indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print(error)
            }
        }
    }
}
    //MARK: - Search Bar Method

    extension TodoListViewController: UISearchBarDelegate {

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated")

        }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadItems()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder() //ben yokum klavyeyi mlavyeyi kaldır
                }
            }
        }
    }


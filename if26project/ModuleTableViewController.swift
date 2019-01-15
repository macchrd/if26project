//
//  ModuleTableViewController.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 11/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import UIKit
import os.log

class ModuleTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    //MARK: Properties
    
    var modules = [Module]()
    var filteredModules = [Module]()
    let db = SingletonBdd.shared
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.rightBarButtonItem = editButtonItem
        
        // Load the sample data.
        loadData()
        
        filteredModules = modules
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        //Initialize search bar
        //searchController.searchBar.scopeButtonTitles = ["All", "Small", "Medium", "Large"]
        //searchController.searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ModuleTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ModuleTableViewCell else{
            fatalError("The dequeued cell is not an instance of EnseignantTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let module = modules[indexPath.row]
        
        cell.sigleLabel.text = module.sigle
        cell.parcoursLabel.text = module.parcours
        cell.categorieLabel.text = module.categorie
        cell.creditLabel.text = String(module.credit)

        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let module = modules.remove(at: indexPath.row)
            print(module.descriptor)
            tableView.deleteRows(at: [indexPath], with: .fade)
            db.deleteModule(rowid: db.getIdModule(sigle: module.sigle))
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new enseignant.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let moduleDetailViewController = segue.destination as? ModuleViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedModuleCell = sender as? ModuleTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedModuleCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedModule = modules[indexPath.row]
            moduleDetailViewController.module = selectedModule
            
        default:
            print("")
        }
    }
    
    //MARK: Actions
    
    @IBAction func unwindToModulesList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ModuleViewController, let module = sourceViewController.module {
            //print(enseignant.descriptor)
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing enseignant.
                modules[selectedIndexPath.row] = module
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
                db.updateModule(id: module.id, sigle: module.sigle, parcours: module.parcours, categorie: module.categorie, credit: module.credit)
            }else {
                // Add a new meal.
                print(modules.count)
                let newIndexPath = IndexPath(row: modules.count, section: 0)
                
                modules.append(module)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                db.insertModule(sigle: module.sigle, parcours: module.parcours, categorie: module.categorie, credit: module.credit)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredModules = modules
        } else {
            // Filter the results
            filteredModules = modules.filter { $0.sigle.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
    
    
    //MARK: Private Methods
    
    private func loadData() {
        // le = ListeEnseignants()
        //db.createTableEnseignant()
        //db.createTableEtudiant()
        //db.createTableModule()
        modules = db.selectAllModules()
    }
    
}

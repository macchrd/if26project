//
//  EnseignantTableViewController.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 11/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import UIKit
import os.log

class EnseignantTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    //MARK: Properties
    
    var enseignants = [Enseignant]()
    var filteredEnseignants = [Enseignant]()
    let db = SingletonBdd.shared
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.rightBarButtonItem = editButtonItem
        
        // Load the sample data.
        loadData()
        
        filteredEnseignants = enseignants
        
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
        return enseignants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "EnseignantTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EnseignantTableViewCell else{
            fatalError("The dequeued cell is not an instance of EnseignantTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let enseignant = enseignants[indexPath.row]
        
        cell.nameLabel.text = enseignant.nom
        cell.surnameLabel.text = enseignant.prenom
        cell.typeLabel.text = enseignant.type

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
            let enseignant = enseignants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            db.deleteEnseignant(rowid: db.getIdEnseignant(nom: enseignant.nom))
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
            guard let enseignantDetailViewController = segue.destination as? EnseignantViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedEnseignantCell = sender as? EnseignantTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEnseignantCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedEnseignant = enseignants[indexPath.row]
            enseignantDetailViewController.enseignant = selectedEnseignant
            
        default:
            print("")
        }
    }
    
    //MARK: Actions
    
    @IBAction func unwindToEnseignantsList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EnseignantViewController, let enseignant = sourceViewController.enseignant {
            //print(enseignant.descriptor)
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing enseignant.
                enseignants[selectedIndexPath.row] = enseignant
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
                db.updateEnseignant(id: enseignant.id, nom: enseignant.nom, prenom: enseignant.prenom, type: enseignant.type, photo: enseignant.photo)
            }else {
                // Add a new meal.
                print(enseignants.count)
                let newIndexPath = IndexPath(row: enseignants.count, section: 0)
                
                enseignants.append(enseignant)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                db.insertEnseignant(nom: enseignant.nom, prenom: enseignant.prenom, type: enseignant.type, photo: enseignant.photo)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredEnseignants = enseignants
        } else {
            // Filter the results
            filteredEnseignants = enseignants.filter { $0.nom.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }

    
    //MARK: Private Methods
    
    private func loadData() {
        // le = ListeEnseignants()
        //db.createTableEnseignant()
        //db.createTableEtudiant()
        //db.createTableEnseignant()
        enseignants = db.selectAllEnseignants()
    }

}

//
//  EtudiantTableViewController.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 11/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import UIKit
import os.log

class EtudiantTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    //MARK: Properties
    
    var etudiants = [Etudiant]()
    var filteredEtudiants = [Etudiant]()
    let db = SingletonBdd.shared
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.rightBarButtonItem = editButtonItem
        
        // Load the sample data.
        loadData()
        
        filteredEtudiants = etudiants
        
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
        return etudiants.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ETudiantTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EtudiantTableViewCell else{
            fatalError("The dequeued cell is not an instance of EnseignantTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let etudiant = etudiants[indexPath.row]
        
        cell.nameLabel.text = etudiant.nom
        cell.surnameLabel.text = etudiant.prenom
        cell.niveauLabel.text = etudiant.niveau
        cell.filiereLabel.text = etudiant.filiere
        
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
            let etudiant = etudiants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            db.deleteEtudiant(rowid: db.getIdEnseignant(nom: etudiant.nom))
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
            guard let etudiantDetailViewController = segue.destination as? EtudiantViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedEtudiantCell = sender as? EtudiantTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEtudiantCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedEtudiant = etudiants[indexPath.row]
            etudiantDetailViewController.etudiant = selectedEtudiant
            
        default:
            print("")
        }
    }
    
    //MARK: Actions
    
    @IBAction func unwindToEnseignantsList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EtudiantViewController, let etudiant = sourceViewController.etudiant {
            //print(enseignant.descriptor)
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing enseignant.
                etudiants[selectedIndexPath.row] = etudiant
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
                db.updateEtudiant(id: etudiant.id, nom: etudiant.nom, prenom: etudiant.prenom, niveau: etudiant.niveau, filiere: etudiant.filiere, photo: etudiant.photo)
            }else {
                // Add a new meal.
                print(etudiants.count)
                let newIndexPath = IndexPath(row: etudiants.count, section: 0)
                
                etudiants.append(etudiant)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                db.insertEtudiant(nom: etudiant.nom, prenom: etudiant.prenom, niveau: etudiant.niveau, filiere: etudiant.filiere, photo: etudiant.photo)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredEtudiants = etudiants
        } else {
            // Filter the results
            filteredEtudiants = etudiants.filter { $0.nom.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
    
    
    //MARK: Private Methods
    
    private func loadData() {
        // le = ListeEnseignants()
        //db.createTableEnseignant()
        //db.createTableEtudiant()
        //db.createTableEnseignant()
        etudiants = db.selectAllEtudiants()
        
    }
    
}


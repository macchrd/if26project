//
//  TableViewController.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 10/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
    var identifiantModuleCellule = "c​​"
    var listeModules: [Module] = []
    
    var listeModuleCat = [String : [Module]]()
    var listeCategories : [String] = []
    //let bdd = SingletonBdd.shared;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let source = Cursus.init()
        //cursus = bdd.selectAll()
        //source.getModules()
        
        
        for module in listeModules {
            if (!listeCategories.contains(module.categorie)){
                listeCategories.append(module.categorie)
                //creation tableau vide
                listeModuleCat[module.categorie] = []
            }
            listeModuleCat[module.categorie]?.append(module)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listeModules.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "c", for: indexPath)
        
        print("indexpath " , indexPath.row)
        print ("Cursus dans  table view size ", listeModules.count)
        let module = listeModules[indexPath.row]
        cell.textLabel?.text = module.sigle
        cell.detailTextLabel?.text = module.categorie + " " + String ( module.credit)
        
        //cell.textLabel?.text = "Cellule \(indexPath.row)"
        //cell.detailTextLabel?.text = "Section \(indexPath.section)"
        return cell
    }
    
    //override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return "Section \(section)"
    //}
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


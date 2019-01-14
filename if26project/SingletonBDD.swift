//
//  SingletonBDD.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 11/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//


import Foundation
import SQLite

class SingletonBdd{
    
    var database: Connection!
    let enseignant_table = Table("enseignant")
    let enseignant_id = Expression<Int>("id")
    let enseignant_nom = Expression<String>("nom")
    let enseignant_prenom = Expression<String>("prenom")
    let enseignant_type = Expression<String>("type")
    let enseignant_photo = Expression<String>("photo")
    var initiated = false;
    
    var pk = 1000;    // valeur de départ pour la primary key
    var tableExist = false   // false la table n'est encore pas créée
    
    static let shared = SingletonBdd()
    
    init(){
        if(self.initiated){}
        else{
            // Do any additional setup after loading the view, typically from a nib.
            print ("-->  Singleton initialized")
            // Il est possible de créer des fichiers dans le répertoire "Documents" de votre application.
            // Ici, création d'un fichier users.sqlite3
            do {let documentDirectory = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask, appropriateFor: nil, create: true)
                let fileUrl = documentDirectory.appendingPathComponent("if26projectBDD").appendingPathExtension("sqlite3")
                let base = try Connection(fileUrl.path)
                self.database = base;
            }catch {
                print (error)
                print ("--> viewDidLoad fin")
            }
            self.initiated = true;
        }
    }
    
    func getConnection() -> Connection{
        return self.database;
    }
    
    func createTableEnseignant() {
        print ("--> createTableModules debut")
        if !self.tableExist {
            self.tableExist = true
            // Instruction pour faire un drop de la table USERS
            let dropTable = self.enseignant_table.drop(ifExists: true)
            // Instruction pour faire un create de la table USERS
            let createTable = self.enseignant_table.create { table in
                table.column(self.enseignant_id, primaryKey: true)
                table.column(self.enseignant_nom)
                table.column(self.enseignant_prenom)
                table.column(self.enseignant_type)
                table.column(self.enseignant_photo)
            }
            do {// Exécution du drop et du create
                try self.database.run(dropTable)
                try self.database.run(createTable)
                print ("Table enseignant est créée")
            }catch {
                print (error)
            }
        }
        print ("--> createTableEnseignants fin")
        
        
        let test = "test"
        insertEnseignant(nom: test, prenom: test, type: test, photo: "?")
    }
    
    func getPK() -> Int {
        var count: Int = 1
        do {try         count = self.database.scalar(enseignant_table.count)+1 }
        catch{
            
        }
        
        self.pk += count
        return self.pk
    }
    
    func deleteEnseignant(rowid:Int)  {
        
        let alice = enseignant_table.filter(enseignant_id == rowid )
        
        //try database.run(alice.update(email <- email.replace("mac.com", with: "me.com")))
        // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
        // WHERE ("id" = 1)
        
        
        do {
            try database.run(alice.delete())
            
        }
        catch {
            print (error)
            print ("--> delete enseignant failed")
        }
        // DELETE FROM "users" WHERE ("id" = 1)
        
        return
    }
    
    
    func insertEnseignant(nom:String, prenom:String, type:String, photo: String) {
        print ("--> insertTableModules debut")
        let insert = self.enseignant_table.insert(self.enseignant_id <- getPK(), self.enseignant_nom <- nom, self.enseignant_prenom <- prenom, self.enseignant_type <- type, self.enseignant_photo <- photo)
        //print(insert)
        do {try self.database.run(insert)
            print ("Insert ok")
            
        }catch {
            print (error)
            print ("--> insertEnseignant failed")
        }
    }
    
    func updateEnseignant(id:Int, nom:String, prenom:String, type:String, photo: String){
        print ("--> updateTableModules debut")
        let enseignant = self.enseignant_table.filter(enseignant_id == id)
        let update = enseignant.update(self.enseignant_nom <- nom, self.enseignant_prenom <- prenom, self.enseignant_type <- type, self.enseignant_photo <- photo)
        do {try self.database.run(update)
            print ("Update ok")
            
        }catch {
            print (error)
            print ("--> updateEnseignant failed")
        }
    }
    
    func getIdEnseignant(nom: String) -> Int{
        print ("--> getRowIdEnseignant debut")
        var id: Int = -1
        print(nom)
        let filteredTable = self.enseignant_table.filter(enseignant_nom == nom)
        
        do {
            let res = try self.database.prepare(filteredTable)
            for enseignant in res{
                id = enseignant[enseignant_id]
                print("id", enseignant[enseignant_id])
            }
            print ("getIdEnseignant ok")
            
        }catch {
            print (error)
            print ("--> getIdEnseignant failed")
        }
        return id
    }
    
    func getEnseignantById(id: Int) -> Enseignant{
        print ("--> getEnseignantById debut")
        
        let filteredTable = self.enseignant_table.filter(enseignant_id == id)
        var ans: Enseignant = Enseignant.init()
        do {
            let res = try self.database.prepare(filteredTable)
            for enseignant in res{
                ans = Enseignant.init(nom: enseignant[self.enseignant_nom], prenom: enseignant[self.enseignant_prenom], type: enseignant[self.enseignant_type])
                ans.id = id
                ans.photo = enseignant[self.enseignant_photo]
                print("id", enseignant[enseignant_id])
            }
            print ("getIdEnseignant ok")
            
        }catch {
            print (error)
            print ("--> getIdEnseignant failed")
        }
        return ans
    }
    
    func countModule() {
    }
    
    func selectAllEnseignants() ->  [Enseignant] {
        print("---> SelectAll debut")
        
        var listeEnseignants: [Enseignant] = []
        //var enseignant: Enseignant;
        
        do{
            let enseignants = try self.database.prepare(self.enseignant_table)
            for enseignant in enseignants{
                print("id: ", enseignant[self.enseignant_id], ", nom: ", enseignant[self.enseignant_nom], ", prenom: ", enseignant[self.enseignant_prenom], ", type: ", enseignant[self.enseignant_type])
                
                listeEnseignants.append((Enseignant.init(nom: enseignant[self.enseignant_nom], prenom: enseignant[self.enseignant_prenom], type: enseignant[self.enseignant_type])))
            }
            
        }catch{
            print(error)
        }
        print("---> SelectAll fin")
        print( "Cursus size", listeEnseignants.count)
        return listeEnseignants
    }
}

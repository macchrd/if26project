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
    
   /* var database: Connection!
    let modules_table = Table("modules")
    let modules_id = Expression<Int>("id")
    let modules_sigle = Expression<String>("sigle")
    let modules_parcours = Expression<String>("parcours")
    let modules_categorie = Expression<String>("categorie")
    let modules_credit = Expression<Int>("credit")
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
                let fileUrl = documentDirectory.appendingPathComponent("modules").appendingPathExtension("sqlite3")
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
    
    func createTable() {
        print ("--> createTableModules debut")
        if !self.tableExist {
            self.tableExist = true
            // Instruction pour faire un drop de la table USERS
            let dropTable = self.modules_table.drop(ifExists: true)
            // Instruction pour faire un create de la table USERS
            let createTable = self.modules_table.create { table in
                table.column(self.modules_id, primaryKey: true)
                table.column(self.modules_sigle)
                table.column(self.modules_parcours)
                table.column(self.modules_categorie)
                table.column(self.modules_credit)
            }
            do {// Exécution du drop et du create
                try self.database.run(dropTable)
                try self.database.run(createTable)
                print ("Table modules est créée")
            }catch {
                print (error)
            }
        }
        print ("--> createTableModules fin")
        
        insertModule(sigle:"String", parcours:"String", categorie:"String",credit:2)
        
    }
    
    func getPK() -> Int {
        self.pk += 1
        return self.pk
    }
    
    func deleteModule(rowid:String)  {
        
        let alice = modules_table.filter(modules_sigle == rowid )
        
        //try database.run(alice.update(email <- email.replace("mac.com", with: "me.com")))
        // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
        // WHERE ("id" = 1)
        
        
        do {
            try database.run(alice.delete())
            
        }
        catch {
            print (error)
            print ("--> insertTableUsers fin")
        }
        // DELETE FROM "users" WHERE ("id" = 1)
        
        return
    }
    
    
    func insertModule(sigle:String, parcours:String, categorie:String,credit:Int) {
        print ("--> insertTableModules debut")
        // Insertion de 2 tuples exemples (sera réalisé à chaque click sur le bouton)
        let insert = self.modules_table.insert(self.modules_id <- getPK(), self.modules_sigle <- sigle, self.modules_parcours <- parcours, self.modules_categorie <- categorie, self.modules_credit <- credit)
        do {try self.database.run(insert)
            print ("Insert ok")
            
        }catch {
            print (error)
            print ("--> insertTableUsers fin")
        }
    }
    
    func countModule() {
    }
    
    func selectAll() ->  [Module] {
        print("---> SelectAll debut")
        
        var cursus: [Module] = []
        var module: Module;
        
        do{
            let modules = try self.database.prepare(self.modules_table)
            for module in modules{
                print("id: ", module[self.modules_id], ", sigle: ", module[self.modules_sigle], ", parcours: ", module[self.modules_parcours], ", categorie: ", module[self.modules_categorie], ", credit: ", module[self.modules_credit])
                
                cursus.append((Module.init(sigle: module[self.modules_sigle], categorie: module[self.modules_categorie], credit: module[self.modules_credit], resultat: Resultat.C)))
            }
            
        }catch{
            print(error)
        }
        print("---> SelectAll fin")
        print( "Cursus size", cursus.count)
        return cursus
    }*/
}

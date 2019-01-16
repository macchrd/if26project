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
    let module_table = Table("module")
    let etudiant_table = Table("etudiant")
    let attribut_id = Expression<Int>("id")
    let attribut_nom = Expression<String>("nom")
    let attribut_prenom = Expression<String>("prenom")
    let attribut_type = Expression<String>("type")
    let attribut_photo = Expression<String>("photo")
    let attribut_sigle = Expression<String>("sigle")
    let attribut_categorie = Expression<String>("categorie")
    let attribut_parcours = Expression<String>("parcours")
    let attribut_credit = Expression<Int>("credit")
    let attribut_niveau = Expression<String>("niveau")
    let attribut_filiere = Expression<String>("filiere")

    var initiated = false;
    
    var pk = 1000;    // valeur de départ pour la primary key
    var tableEnseignantExist = false   // false la table n'est encore pas créée
    var tableModuleExist = false   // false la table n'est encore pas créée
    var tableEtudiantExist = false   // false la table n'est encore pas créée

    
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
    
    func createTableEtudiant() {
        print ("--> createTableEtudiant debut")
        if !self.tableEtudiantExist {
            self.tableEtudiantExist = true
            // Instruction pour faire un drop de la table USERS
            let dropTable = self.etudiant_table.drop(ifExists: true)
            // Instruction pour faire un create de la table USERS
            let createTable = self.etudiant_table.create { table in
                table.column(self.attribut_id, primaryKey: true)
                table.column(self.attribut_nom)
                table.column(self.attribut_prenom)
                table.column(self.attribut_niveau)
                table.column(self.attribut_filiere)
                table.column(self.attribut_photo)
            }
            do {// Exécution du drop et du create
                try self.database.run(dropTable)
                try self.database.run(createTable)
                print ("Table etudiant est créée")
            }catch {
                print (error)
            }
        }
        print ("--> createTableEtudiant fin")
        
        let listEtudiants : ListeEtudiants = ListeEtudiants.init()
        let l = listEtudiants.getEtudiants()
        for etudiant in l {
            insertEtudiant(nom: etudiant.nom, prenom: etudiant.prenom, niveau: etudiant.niveau, filiere: etudiant.filiere, photo: etudiant.photo)
        }
    }
    func createTableModule() {
        print ("--> createTableModule debut")
        if !self.tableModuleExist {
            self.tableModuleExist = true
            // Instruction pour faire un drop de la table USERS
            let dropTable = self.module_table.drop(ifExists: true)
            // Instruction pour faire un create de la table USERS
            let createTable = self.module_table.create { table in
                table.column(self.attribut_id, primaryKey: true)
                table.column(self.attribut_sigle)
                table.column(self.attribut_parcours)
                table.column(self.attribut_categorie)
                table.column(self.attribut_credit)
            }
            do {// Exécution du drop et du create
                try self.database.run(dropTable)
                try self.database.run(createTable)
                print ("Table module est créée")
            }catch {
                print (error)
            }
        }
        print ("--> createTableModule fin")
        
        
        let listModules : ListeModules = ListeModules.init()
        let l = listModules.getModules()
        for module in l {
            insertModule(sigle: module.sigle, parcours: module.parcours, categorie: module.categorie, credit: module.credit)
        }
    }
    
    func createTableEnseignant() {
        print ("--> createTableEnseignant debut")
        if !self.tableEnseignantExist {
            self.tableEnseignantExist = true
            // Instruction pour faire un drop de la table USERS
            let dropTable = self.enseignant_table.drop(ifExists: true)
            // Instruction pour faire un create de la table USERS
            let createTable = self.enseignant_table.create { table in
                table.column(self.attribut_id, primaryKey: true)
                table.column(self.attribut_nom)
                table.column(self.attribut_prenom)
                table.column(self.attribut_type)
                table.column(self.attribut_photo)
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
        
        let listEnseignants : ListeEnseignants = ListeEnseignants.init()
        let l = listEnseignants.getEnseignants()
        for enseignant in l {
            insertEnseignant(nom: enseignant.nom, prenom: enseignant.prenom, type: enseignant.type, photo: "?")
        }
    }
    
    func getPKEnseignant() -> Int {
        var count: Int = 1
        do {try         count = self.database.scalar(enseignant_table.count)+1 }
        catch{
            
        }
        let pk = self.pk + count
        return pk
    }
    
    func getPKEtudiant() -> Int {
        var count: Int = 1
        do {try         count = self.database.scalar(etudiant_table.count)+1 }
        catch{
            
        }
        
        let pk = self.pk + count
        return pk
    }
    
    func getPKModule() -> Int {
        var count: Int = 1
        do {try         count = self.database.scalar(module_table.count)+1 }
        catch{
            
        }
        
        let pk = self.pk + count
        return pk
    }
    
    func deleteEnseignant(rowid:Int)  {
        
        let alice = enseignant_table.filter(attribut_id == rowid )
        
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
    
    func deleteEtudiant(rowid:Int)  {
        
        let alice = etudiant_table.filter(attribut_id == rowid )
        
        //try database.run(alice.update(email <- email.replace("mac.com", with: "me.com")))
        // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
        // WHERE ("id" = 1)
        
        
        do {
            try database.run(alice.delete())
            
        }
        catch {
            print (error)
            print ("--> delete etudiant failed")
        }
        // DELETE FROM "users" WHERE ("id" = 1)
        
        return
    }
    
    func deleteModule(rowid:Int)  {
        
        let alice = module_table.filter(attribut_id == rowid )
        
        //try database.run(alice.update(email <- email.replace("mac.com", with: "me.com")))
        // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
        // WHERE ("id" = 1)
        
        
        do {
            try database.run(alice.delete())
            print ("--> delete module ok")
            
        }
        catch {
            print (error)
            print ("--> delete module failed")
        }
        // DELETE FROM "users" WHERE ("id" = 1)
        
        return
    }
    
    
    func insertEnseignant(nom:String, prenom:String, type:String, photo: String) {
        print ("--> insertTablEnseignant debut")
        let insert = self.enseignant_table.insert(self.attribut_id <- getPKEnseignant(), self.attribut_nom <- nom, self.attribut_prenom <- prenom, self.attribut_type <- type, self.attribut_photo <- photo)
        //print(insert)
        do {try self.database.run(insert)
            print ("Insert ok")
            
        }catch {
            print (error)
            print ("--> insertEnseignant failed")
        }
    }
    
    func insertEtudiant(nom:String, prenom:String, niveau:String, filiere: String, photo: String) {
        print ("--> insertTableEtudiant debut")
        let insert = self.etudiant_table.insert(self.attribut_id <- getPKEtudiant(), self.attribut_nom <- nom, self.attribut_prenom <- prenom, self.attribut_niveau <- niveau, self.attribut_filiere <- filiere, self.attribut_photo <- photo)
        //print(insert)
        do {try self.database.run(insert)
            print ("Insert ok")
            
        }catch {
            print (error)
            print ("--> insertEnseignant failed")
        }
    }
    
    func insertModule(sigle:String, parcours:String, categorie:String, credit: Int) {
        print ("--> insertTableModules debut")
        let insert = self.module_table.insert(self.attribut_id <- getPKModule(), self.attribut_sigle <- sigle, self.attribut_parcours <- parcours, self.attribut_categorie <- categorie, self.attribut_credit <- credit)
        //print(insert)
        do {try self.database.run(insert)
            print ("Insert ok")
            
        }catch {
            print (error)
            print ("--> insertModule failed")
        }
    }
    
    func updateEnseignant(id:Int, nom:String, prenom:String, type:String, photo: String){
        print ("--> updateTableEnseignant debut")
        let enseignant = self.enseignant_table.filter(attribut_id == id)
        let update = enseignant.update(self.attribut_nom <- nom, self.attribut_prenom <- prenom, self.attribut_type <- type, self.attribut_photo <- photo)
        do {try self.database.run(update)
            print ("Update ok")
            
        }catch {
            print (error)
            print ("--> updateEnseignant failed")
        }
    }
    
    func updateEtudiant(id:Int, nom:String, prenom:String, niveau:String, filiere: String, photo: String){
        print ("--> updateTableEtudiant debut")
        let etudiant = self.etudiant_table.filter(attribut_id == id)
        let update = etudiant.update(self.attribut_nom <- nom, self.attribut_prenom <- prenom, self.attribut_niveau <- niveau, self.attribut_filiere <- filiere, self.attribut_photo <- photo)
        do {try self.database.run(update)
            print ("Update ok")
            
        }catch {
            print (error)
            print ("--> updateEtudiant failed")
        }
    }
    
    func updateModule(id:Int, sigle:String, parcours:String, categorie:String, credit: Int){
        print ("--> updateTableModules debut")
        let module = self.module_table.filter(attribut_id == id)
        let update = module.update(self.attribut_sigle <- sigle, self.attribut_categorie <- categorie, self.attribut_parcours <- parcours, self.attribut_credit <- credit)
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
        let filteredTable = self.enseignant_table.filter(attribut_nom == nom)
        
        do {
            let res = try self.database.prepare(filteredTable)
            for enseignant in res{
                id = enseignant[attribut_id]
                print("id", enseignant[attribut_id])
            }
            print ("getIdEnseignant ok")
            
        }catch {
            print (error)
            print ("--> getIdEnseignant failed")
        }
        return id
    }
    
    func getIdEtudiant(nom: String) -> Int{
        print ("--> getRowIdEtudiant debut")
        var id: Int = -1
        print(nom)
        let filteredTable = self.etudiant_table.filter(attribut_nom == nom)
        
        do {
            let res = try self.database.prepare(filteredTable)
            for etudiant in res{
                id = etudiant[attribut_id]
                print("id", etudiant[attribut_id])
            }
            print ("getIdEtudiant ok")
            
        }catch {
            print (error)
            print ("--> getIdEtudiant failed")
        }
        return id
    }
    
    func getIdModule(sigle: String) -> Int{
        print ("--> getRowIdSigle debut")
        var id: Int = -1
        print(sigle)
        let filteredTable = self.module_table.filter(attribut_sigle == sigle)
        
        do {
            let res = try self.database.prepare(filteredTable)
            for module in res{
                id = module[attribut_id]
                print("id", module[attribut_id])
            }
            print ("getIdSigle ok")
            
        }catch {
            print (error)
            print ("--> getIdSigle failed")
        }
        print(id)
        return id
    }
    
    func getEnseignantById(id: Int) -> Enseignant{
        print ("--> getEnseignantById debut")
        
        let filteredTable = self.enseignant_table.filter(attribut_id == id)
        var ans: Enseignant = Enseignant.init()
        do {
            let res = try self.database.prepare(filteredTable)
            for enseignant in res{
                ans = Enseignant.init(nom: enseignant[self.attribut_nom], prenom: enseignant[self.attribut_prenom], type: enseignant[self.attribut_type])
                ans.id = id
                ans.photo = enseignant[self.attribut_photo]
                print("id", enseignant[attribut_id])
            }
            print ("getIdEnseignant ok")
            
        }catch {
            print (error)
            print ("--> getIdEnseignant failed")
        }
        return ans
    }
    
    func getEtudiantById(id: Int) -> Etudiant{
        print ("--> getEtudiantById debut")
        
        let filteredTable = self.etudiant_table.filter(attribut_id == id)
        var ans: Etudiant = Etudiant.init()
        do {
            let res = try self.database.prepare(filteredTable)
            for etudiant in res{
                ans = Etudiant.init(nom: etudiant[self.attribut_nom], prenom: etudiant[self.attribut_prenom], niveau: etudiant[self.attribut_niveau], filiere: etudiant[self.attribut_filiere])
                ans.id = id
                ans.photo = etudiant[self.attribut_photo]
                print("id", etudiant[attribut_id])
            }
            print ("getIdEtudiant ok")
            
        }catch {
            print (error)
            print ("--> getIdEtudiant failed")
        }
        return ans
    }
    
    func getModuleById(id: Int) -> Module{
        print ("--> getModuleById debut")
        
        let filteredTable = self.module_table.filter(attribut_id == id)
        var ans: Module = Module.init()
        do {
            let res = try self.database.prepare(filteredTable)
            for module in res{
                ans = Module.init(sigle: module[self.attribut_sigle], parcours: module[self.attribut_parcours], categorie: module[self.attribut_categorie], credit: module[self.attribut_credit])
                ans.id = id
                print("id", module[attribut_id])
            }
            print ("getIdModule ok")
            
        }catch {
            print (error)
            print ("--> getIdModule failed")
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
                print("id: ", enseignant[self.attribut_id], ", nom: ", enseignant[self.attribut_nom], ", prenom: ", enseignant[self.attribut_prenom], ", type: ", enseignant[self.attribut_type])
                
                listeEnseignants.append((Enseignant.init(nom: enseignant[self.attribut_nom], prenom: enseignant[self.attribut_prenom], type: enseignant[self.attribut_type])))
            }
            
        }catch{
            print(error)
        }
        print("---> SelectAll fin")
        print( "size", listeEnseignants.count)
        return listeEnseignants
    }
    
    func selectAllEtudiants() ->  [Etudiant] {
        print("---> SelectAll debut")
        
        var listeEtudiants: [Etudiant] = []
        //var enseignant: Enseignant;
        
        do{
            let etudiants = try self.database.prepare(self.etudiant_table)
            for etudiant in etudiants{
                print("id: ", etudiant[self.attribut_id], ", nom: ", etudiant[self.attribut_nom], ", prenom: ", etudiant[self.attribut_prenom], ", niveau: ", etudiant[self.attribut_niveau],  ", filiere: ", etudiant[self.attribut_filiere])
                
                listeEtudiants.append((Etudiant.init(nom: etudiant[self.attribut_nom], prenom: etudiant[self.attribut_prenom], niveau: etudiant[self.attribut_niveau], filiere: etudiant[self.attribut_filiere])))
            }
            
        }catch{
            print(error)
        }
        print("---> SelectAll fin")
        print( "size", listeEtudiants.count)
        return listeEtudiants
    }
    
    func selectAllModules() ->  [Module] {
        print("---> SelectAll debut")
        
        var listeModules: [Module] = []
        //var enseignant: Enseignant;
        
        do{
            let modules = try self.database.prepare(self.module_table)
            for module in modules{
                listeModules.append(Module.init(sigle: module[self.attribut_sigle], parcours: module[self.attribut_parcours], categorie: module[self.attribut_categorie], credit: module[self.attribut_credit]))
            }
            
        }catch{
            print(error)
        }
        print("---> SelectAll fin")
        print( "size", listeModules.count)
        return listeModules
    }
}

//
//  ListeEtudiants.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 10/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import Foundation

public class ListeEtudiants {
    var etudiants: [Etudiant];
    
    func ajoute(m: Etudiant) {
        etudiants.append(m)
    }
    
    init() {
        etudiants = []
        ajoute(m:Etudiant.init(nom: "Deblin", prenom: "Samy", niveau: "ISI1", filiere: "?"))
        ajoute(m:Etudiant.init(nom: "Tost", prenom: "Mael", niveau: "ISI4", filiere: "MPL"))
        ajoute(m:Etudiant.init(nom: "Teronal", prenom: "Kevin", niveau: "ISI5", filiere: "MCS"))
        ajoute(m:Etudiant.init(nom: "Saponi", prenom: "Pol", niveau: "ISI8", filiere: "MSI"))
        ajoute(m:Etudiant.init(nom: "Palomer", prenom: "Astrid", niveau: "ISI2", filiere: "?"))
    }
    
    func getNoms() -> [String] {
        var res: [String] = []
        for etudiant in etudiants {
            res.append (etudiant.nom)
        }
        return res;
    }
    
    func getEtudiant(position: Int) -> Etudiant {
        let etudiant: Etudiant = etudiants[position]
        return etudiant;
    }
    
    func getEtudiants() -> [Etudiant] {
        return etudiants;
    }
    
    func count() -> Int {
        return etudiants.count
    }
}


//
//  Etudiant.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 10/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//
import Foundation


public class Etudiant  {
    
    var id: Int
    var nom: String
    var prenom: String
    var niveau: String
    var filiere: String
    var photo: String
    
    init() {
        id = 1
        nom = "?"
        prenom = "?"
        niveau = "?"
        filiere = "?"
        photo = "?"
    }
    
    init(nom: String, prenom: String, niveau: String, filiere: String) {
        id = 1
        self.nom = nom
        self.prenom = prenom
        self.niveau = niveau
        self.filiere = filiere
        photo = "?"
    }
    
    public var descriptor: String {
        return "Etudiant(\(nom),\(prenom),\(niveau),\(filiere))"
    }
}


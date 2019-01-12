//
//  Enseignant.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 10/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import Foundation

public class Enseignant  {
    
    var id: Int
    var nom: String
    var prenom: String
    var type: String
    var photo: String
    
    init() {
        id = 1
        nom = "?"
        prenom = "?"
        type = "?"
        photo = "?"
    }
    
    init(nom: String, prenom: String, type: String) {
        id = 1
        self.nom = nom
        self.prenom = prenom
        self.type = type
        photo = "?"
    }
    
    public var descriptor: String {
        return "Enseignant(\(nom),\(prenom),\(type),\(photo))"
    }
}

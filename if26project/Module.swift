//
//  Module.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 10/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import Foundation


public class Module  {
    var sigle: String
    var categorie: String
    var credit: Int
    var parcours: String
    
    init() {
        sigle = "?"
        categorie = "?"
        credit = 0
        parcours = "?"
    }
    
    init(sigle: String, parcours: String, categorie: String, credit: Int) {
        self.sigle = sigle
        self.categorie = categorie
        self.credit = credit
        self.parcours = parcours
    }
    
    public var descriptor: String {
        return "Module(\(sigle),\(parcours),\(categorie),\(credit))"
    }
}

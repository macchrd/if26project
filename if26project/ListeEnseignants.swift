//
//  ListeEnseignants.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 10/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import Foundation

public class ListeEnseignants {
    var enseignants: [Enseignant];
    
    func ajoute(m: Enseignant) {
        enseignants.append(m)
    }
    
    init() {
        enseignants = []
        ajoute(m:Enseignant.init(nom: "Debois", prenom: "Michel", type: "Contractuel"))
        ajoute(m:Enseignant.init(nom: "Trust", prenom: "Philippe", type: "Maitre de conférence"))
        ajoute(m:Enseignant.init(nom: "Ternational", prenom: "Alain", type: "Contractuel"))
        ajoute(m:Enseignant.init(nom: "Slop", prenom: "Lucas", type: "Professeur"))
        ajoute(m:Enseignant.init(nom: "Parker", prenom: "Tony", type: "Contractuel"))
    }
    
    func getNoms() -> [String] {
        var res: [String] = []
        for enseignant in enseignants {
            res.append (enseignant.nom)
        }
        return res;
    }
    
    func getEnseignant(position: Int) -> Enseignant {
        let enseignant: Enseignant = enseignants[position]
        return enseignant;
    }
    
    func getEnseignants() -> [Enseignant] {
        return enseignants;
    }
    
    func count() -> Int {
        return enseignants.count
    }
}

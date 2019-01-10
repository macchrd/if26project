//
//  ListeModules.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 10/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import Foundation

public class ListeModules {
    var modules: [Module];
    
    func ajoute(m: Module) {
        modules.append(m)
    }
    
    init() {
        modules = []
        ajoute(m:Module.init(sigle: "LO07", parcours: "TCBR", categorie: "TM", credit: 6))
        ajoute(m:Module.init(sigle: "IF26", parcours: "MPL", categorie: "TM", credit: 6))
        ajoute(m:Module.init(sigle: "NF19", parcours: "TCBR", categorie: "TM", credit: 6))
        ajoute(m:Module.init(sigle: "NF16", parcours: "TCBR", categorie: "CS", credit: 6))
        ajoute(m:Module.init(sigle: "IF10", parcours: "MCS", categorie: "TM", credit: 6))
        ajoute(m:Module.init(sigle: "IF43", parcours: "MSI", categorie: "CS", credit: 6))
    }
    
    func getSigles() -> [String] {
        var res: [String] = []
        for module in modules {
            res.append (module.sigle)
        }
        return res;
    }
    
    func getModule(position: Int) -> Module {
        let module: Module = modules[position]
        return module;
    }
    
    func getModules() -> [Module] {
        return modules;
    }
    
    func count() -> Int {
        return modules.count
    }
}



//
//  statsViewController.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 16/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import UIKit
import os.log

class StatsViewController: UIViewController {
    
    
    @IBOutlet weak var lblEnseignants: UITextView!
    @IBOutlet weak var lblModules: UITextView!
    @IBOutlet weak var lblEtudiants: UITextView!
    
    
    let db = SingletonBdd.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var nms = db.countEnseignants()
        self.lblEnseignants.text = "Il y a "+String(nms[0])+" enseignants dans le département dont "+String(nms[3])+" professeurs, "+String(nms[2])+" maitres de conférence, "+String(nms[1])+" contractuels"
        
        nms = db.countModules()
        self.lblModules.text = "Il y a "+String(nms[0])+"modules dans le département dont "+String(nms[1])+" CS et "+String(nms[2])+" TM"
        
        nms = db.countEtudiants()
        self.lblEtudiants.text = "Il y a "+String(nms[0])+"etudiants dans le département dont "+String(nms[1])+" en MSI, "+String(nms[2])+" en MCS et "+String(nms[2])+" en MPL"
    }
}


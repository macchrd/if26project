//
//  statsViewController.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 16/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import UIKit
import os.log

class statsViewController: UIViewController, UITextFieldDelegate   {

    override func viewDidLoad() {
        super.viewDidLoad()
        et_sigle.delegate = self
        et_credit.delegate = self
    
    }
}


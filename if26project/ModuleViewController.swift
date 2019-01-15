//
//  ModuleViewController.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 11/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import UIKit
import os.log

class ModuleViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource   {

    @IBOutlet weak var et_sigle: UITextField!
    @IBOutlet weak var et_parcours: UIPickerView!
    @IBOutlet weak var et_categorie: UIPickerView!
    @IBOutlet weak var et_credit: UITextField!
    
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var module: Module?
    let db = SingletonBdd.shared
    let parcoursList = ["TCBR","MSI","MCS", "MPL"]
    let categorieList = ["CS","TM"]
    var moduleHasChanged: Bool = false
    var oldSigle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        et_sigle.delegate = self
        et_credit.delegate = self
        
        et_parcours.delegate = self
        et_parcours.dataSource = self
        
        et_categorie.delegate = self
        et_categorie.dataSource = self
        
        updateSaveButtonState()
        
        if let module = self.module {
            navigationItem.title = module.sigle
            oldSigle = module.sigle
            et_sigle.text   = module.sigle
            et_credit.text   = String(module.credit)
            
            switch(module.parcours) {
                
            case "TCBR":
                et_parcours.selectRow(0, inComponent: 0, animated: true)
            case "MSI":
                et_parcours.selectRow(1, inComponent: 0, animated: true)
            case "MCS":
                et_parcours.selectRow(2, inComponent: 0, animated: true)
            case "MPL":
                et_parcours.selectRow(3, inComponent: 0, animated: true)
            default:
                print("")
            }
            
            switch(module.categorie) {
                
            case "CS":
                et_categorie.selectRow(0, inComponent: 0, animated: true)
            case "TM":
                et_categorie.selectRow(1, inComponent: 0, animated: true)
            default:
                print("")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancell(_ sender: UIBarButtonItem) {
        let isPresentingInAddModuleMode = presentingViewController is UINavigationController
        if isPresentingInAddModuleMode {
            dismiss(animated: true, completion: nil)
        }else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }else {
            fatalError("The ModuleViewController is not inside a navigation controller.")
        }
    }
    
    //This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let sigle = et_sigle.text ?? ""
        let parcours = self.parcoursList[et_parcours.selectedRow(inComponent: 0)]
        let categorie = self.categorieList[et_categorie.selectedRow(inComponent: 0)]
        let credit = Int(et_credit.text ?? "")
        
        // Set the module to be passed to ModuleTableViewController after the unwind segue.
        
        module = Module(sigle: sigle, parcours: parcours, categorie: categorie, credit: credit!)
        module?.id = db.getIdModule(sigle: oldSigle)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView === et_parcours){
            return parcoursList.count
        }else{
            return categorieList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView === et_parcours){
            return parcoursList[row]
        }else{
            return categorieList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        moduleHasChanged = true
        updateSaveButtonState()
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let sigle = et_sigle.text ?? ""
        let credit = et_credit.text ?? ""
        saveButton.isEnabled = (!sigle.isEmpty && !credit.isEmpty) || moduleHasChanged
    }
}

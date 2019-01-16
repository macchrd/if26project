//
//  EtudiantViewController.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 11/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import UIKit
import os.log

class EtudiantViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource   {
    
    @IBOutlet weak var et_name: UITextField!
    @IBOutlet weak var et_surname: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var et_niveau: UIPickerView!
    @IBOutlet weak var et_filiere: UIPickerView!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var etudiant: Etudiant?
    let db = SingletonBdd.shared
    var oldName: String = ""
    let niveauList = ["ISI1","ISI2","ISI3","ISI4","ISI5","ISI6","ISI7","ISI8"]
    let filiereList = ["TCBR","MSI","MCS", "MPL"]
    var photoHasChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        et_name.delegate = self
        et_surname.delegate = self
        et_name.delegate = self
        et_surname.delegate = self
        
        et_niveau.delegate = self
        et_niveau.dataSource = self
        
        et_filiere.delegate = self
        et_filiere.dataSource = self
        
        updateSaveButtonState()
        
        if let etudiant = self.etudiant {
            print(etudiant.nom)
            navigationItem.title = etudiant.nom
            oldName = etudiant.nom
            et_name.text   = etudiant.nom
            et_surname.text   = etudiant.prenom
            
            switch(etudiant.niveau) {
                
            case "ISI1":
                et_niveau.selectRow(0, inComponent: 0, animated: true)
            case "ISI2":
                et_niveau.selectRow(1, inComponent: 0, animated: true)
            case "ISI3":
                et_niveau.selectRow(2, inComponent: 0, animated: true)
            case "ISI4":
                et_niveau.selectRow(3, inComponent: 0, animated: true)
            case "ISI5":
                et_niveau.selectRow(4, inComponent: 0, animated: true)
            case "ISI6":
                et_niveau.selectRow(5, inComponent: 0, animated: true)
            case "ISI7":
                et_niveau.selectRow(6, inComponent: 0, animated: true)
            case "ISI8":
                et_niveau.selectRow(7, inComponent: 0, animated: true)
            default:
                print("")
            }
            
            switch(etudiant.filiere) {
                
            case "TCBR":
                et_filiere.selectRow(0, inComponent: 0, animated: true)
            case "MSI":
                et_filiere.selectRow(1, inComponent: 0, animated: true)
            case "MCS":
                et_filiere.selectRow(2, inComponent: 0, animated: true)
            case "MPL":
                et_filiere.selectRow(3, inComponent: 0, animated: true)
            default:
                print("")
            }
            
            
            let e = db.getEtudiantById(id: db.getIdEtudiant(nom: oldName))
            //print(e.descriptor)
            if(e.photo != "?"){
                let dataDecoded : Data = Data(base64Encoded: e.photo, options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                image.image = decodedimage
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Navigation
    
    @IBAction func cancell(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }else {
            fatalError("The MealViewController is not inside a navigation controller.")
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
        
        let name = et_name.text ?? ""
        let surname = et_surname.text ?? ""
        let niveau = niveauList[et_niveau.selectedRow(inComponent: 0)]
        let filiere = filiereList[et_filiere.selectedRow(inComponent: 0)]

        
        let photo : UIImage = image.image!
        let imageData:NSData = UIImagePNGRepresentation(photo)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        // Set the enseignant to be passed to EnseignantTableViewController after the unwind segue.
        
        etudiant = Etudiant(nom: name, prenom: surname, niveau: niveau, filiere: filiere)
        etudiant?.id = db.getIdEtudiant(nom: oldName)
        etudiant?.photo = strBase64
    }
    
    //MARK: Actions comment in ViewController.swift
    
    @IBAction func selectImage(_ sender: UIButton) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        image.image = selectedImage
        photoHasChanged = true
        updateSaveButtonState()
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UIPickerDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView === et_niveau){
            return niveauList.count
        }else{
            return filiereList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView === et_niveau){
            return niveauList[row]
        }else{
            return filiereList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        photoHasChanged = true
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
        let name = et_name.text ?? ""
        let surname = et_surname.text ?? ""
        saveButton.isEnabled = (!name.isEmpty && !surname.isEmpty) || photoHasChanged
    }
}

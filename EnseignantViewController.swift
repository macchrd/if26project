//
//  EnseignantViewController.swift
//  if26project
//
//  Created by CACHARD MARC-ANTOINE on 11/01/2019.
//  Copyright © 2019 CACHARD MARC-ANTOINE. All rights reserved.
//

import UIKit
import os.log

class EnseignantViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var et_name: UITextField!
    @IBOutlet weak var et_surname: UITextField!
    @IBOutlet weak var et_type: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var enseignant: Enseignant?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        et_name.delegate = self
        et_surname.delegate = self
        et_type.delegate = self
        
        updateSaveButtonState()
        
        if let enseignant = self.enseignant {
            navigationItem.title = enseignant.nom
            et_name.text   = enseignant.nom
            et_surname.text   = enseignant.prenom
            et_type.text   = enseignant.type
            //image = enseignant.photo
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
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
        let type = et_type.text ?? ""
        //let photo = image.image
        
        // Set the enseignant to be passed to EnseignantTableViewController after the unwind segue.
        enseignant = Enseignant(nom: name, prenom: surname, type: type)
        //enseignant?.photo = photo    Need to pass it in base64
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
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
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
        let type = et_type.text ?? ""
        saveButton.isEnabled = !name.isEmpty && !surname.isEmpty && !type.isEmpty
    }
}

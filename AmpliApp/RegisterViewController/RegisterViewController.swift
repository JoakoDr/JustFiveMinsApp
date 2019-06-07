//
//  RegisterViewController.swift
//  AmpliApp
//
//  Created by Joaquin Diaz on 27/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import UIKit
import DLRadioButton
import ValidationComponents
import TextFieldEffects
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController, Api {
    @IBOutlet var txtEmail:AkiraTextField?
    @IBOutlet var txtName:AkiraTextField?
    @IBOutlet var txtBirthday:AkiraTextField?
    //Uidate picker
    let datePicker = UIDatePicker()
    @IBOutlet var txtPassword1:AkiraTextField?
    @IBOutlet var txtPassword2:AkiraTextField?
    @IBOutlet var backBtn:UIButton?
    @IBOutlet var nextButton:UIButton?
    @IBOutlet var lblError:UILabel?
    var radioButtonValue:String!
    var bool:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        roundButton()
        setTargets()
        // Do any additional setup after loading the view.
    }
    func createUserApi(blFinRegistro: Bool) {
        if blFinRegistro {
            let locationVC = LocationViewController()
            navigationController?.pushViewController(locationVC, animated: false)
        }
        
    }
    @objc @IBAction fileprivate func logSelectedButton(_ radioButton : DLRadioButton){
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(button.titleLabel!.text!+" is selected. \n")
            }
        } else {
            for button in radioButton.selectedButtons() {
            radioButtonValue = radioButton.selected()!.titleLabel!.text!
            print(button.titleLabel!.text! + " is selected. \n")
            }
        }
    }

    func roundButton()
    {
        backBtn?.layer.cornerRadius = 5
        nextButton?.layer.cornerRadius = 5
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        txtBirthday?.inputAccessoryView = toolbar
        // add datepicker to textField
        txtBirthday?.inputView = datePicker
        
    }
    
    @objc func doneDatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        txtBirthday?.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    //func contains Numbers
    func doStringContainsNumber( _string : String) -> Bool{
        
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: _string)
        
        return containsNumber
    }
    
    
    
    //Password1
    @IBAction func textFieldEditingDidChangePass1(_ sender: Any) {
        if ((txtPassword1?.text?.count)! >= 6)
        { if (doStringContainsNumber(_string: (txtPassword1?.text)!))
        {
            lblError?.text = "Contraseña Valida"
            txtPassword1?.layer.borderColor = UIColor.green.cgColor
        }
        else
        {
            lblError?.text = "Contraseña Invalida,le falta un numero"
            txtPassword1?.layer.borderColor = UIColor.red.cgColor
            }
        }
        else
        {
            lblError?.text = "Contraseña debe de ser mas larga de 6"
            txtPassword1?.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    @IBAction func textFieldEditingDidChangePass2(_ sender: Any) {
        
        if(txtPassword1?.text == txtPassword2?.text){
            lblError?.text = "Las contraseñas coinciden"
            txtPassword2?.layer.borderColor = UIColor.green.cgColor
            txtPassword1?.layer.borderColor = UIColor.green.cgColor
            } else
            {
            lblError?.text = "Las contraseñas no coinciden"
                txtPassword2?.layer.borderColor = UIColor.red.cgColor
                txtPassword1?.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    @IBAction func textFieldEditingDidChangeEmail(_ sender: Any) {
        let emailValidator = EmailValidationPredicate()
        if(emailValidator.evaluate(with:txtEmail?.text)){
            lblError?.text = "El email es correcto"
            txtEmail?.layer.borderColor = UIColor.green.cgColor
            } else {
            lblError?.text = "El email es incorrecto"
            txtEmail?.layer.borderColor = UIColor.red.cgColor
        }
        
    }
    @IBAction func textFieldEditingDidChangeName(_ sender: Any) {
        
        if((txtName?.text?.count)! > 11){
            lblError?.text = "No se pueden introducir mas de 11 caracteres"
            txtName?.layer.borderColor = UIColor.red.cgColor
        } else
        {
            txtName?.layer.borderColor = UIColor.green.cgColor
        }
        
    }
    
    
    func enableButton()
    {
        if(bool == true)
        {
            print("Todos los campos son correctos")
            nextButton?.isEnabled = true
        }else
        {
            print("Algun campos no es correcto")
            nextButton?.isEnabled = false
        }
        
        
    }
    
    
    //Set Targets
    func setTargets()
    {
        txtPassword1?.addTarget(self, action: #selector(textFieldEditingDidChangePass1), for: UIControlEvents.editingChanged)
        txtPassword2?.addTarget(self, action: #selector(textFieldEditingDidChangePass2), for: UIControlEvents.editingChanged)
        txtEmail?.addTarget(self, action: #selector(textFieldEditingDidChangeEmail), for: UIControlEvents.editingChanged)
        txtName?.addTarget(self, action: #selector(textFieldEditingDidChangeName), for: UIControlEvents.editingChanged)
    }
    @IBAction func clickNext(_ sender: UIButton!) {
        
        FirebaseApiManager.sharedInstance.miPerfil.sEmail = txtEmail?.text
        FirebaseApiManager.sharedInstance.miPerfil.sName = txtName?.text
        FirebaseApiManager.sharedInstance.miPerfil.sBirthday = txtBirthday?.text
        FirebaseApiManager.sharedInstance.miPerfil.sGender = radioButtonValue
        
        if((txtPassword1?.text?.count)! >= 6){
            FirebaseApiManager.sharedInstance.registrarse(email: (txtEmail?.text)!, password: (txtPassword1?.text)!, delegate: self as Api)
            print("Ha hecho el registro?")
            let locationVC = LocationViewController()
            navigationController?.pushViewController(locationVC, animated: false)
        }
       
        
    }
    @IBAction func clickBack(_ sender: UIButton!) {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

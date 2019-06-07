//
//  LoginViewController.swift
//  AmpliApp
//
//  Created by Dario Autric on 9/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import UIKit
import ValidationComponents
import TextFieldEffects
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController, UITextFieldDelegate, Api {
    
    @IBOutlet var txtEmail:AkiraTextField?
    @IBOutlet var txtPassword:AkiraTextField?
    @IBOutlet var loginBtn:UIButton?
    @IBOutlet var registerBtn:UIButton?
    @IBOutlet var lblError:UILabel?
     var boolValidatePass:Bool? = false
    var boolValidateEmail:Bool? = false
    let emailValidator = EmailValidationPredicate()
    let alert:UIAlertController = UIAlertController(title: "Error en tu e-mail o contraseña", message:  "¡Vuelve a intentarlo otra vez!", preferredStyle: UIAlertControllerStyle.actionSheet)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        roundButton()
        setupTargets()
        //buttonEnabled()
        Auth.auth().addStateDidChangeListener { (auth, user) in
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func clickLogin(_ sender: UIButton!) {
        
        FirebaseApiManager.sharedInstance.login(email: (txtEmail?.text)!, password: (txtPassword?.text)!, delegate: self )
        
    }
    @IBAction func clickRegister(_ sender: UIButton!) {
        let registerVC = RegisterViewController()
    navigationController?.pushViewController(registerVC, animated: false)
    }
    func roundButton()
    {
        loginBtn?.layer.cornerRadius = 5
        registerBtn?.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func doStringContainsNumber( _string : String) -> Bool{
        
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: _string)
        
        return containsNumber
    }
    @IBAction func textFieldEditingDidChangePass(_ sender: Any) {
        if ((txtPassword?.text?.count)! >= 6)
        { if (doStringContainsNumber(_string: (txtPassword?.text)!))
        {
            lblError?.text = "Contraseña Valida"
            txtPassword?.layer.borderColor = UIColor.green.cgColor
            self.boolValidatePass = true
            }
            else
            {
                lblError?.text = "Contraseña Invalida,le falta un numero"
                txtPassword?.layer.borderColor = UIColor.red.cgColor
                
            }
        }
        else
        {
            lblError?.text = "Contraseña debe de ser mas larga de 6"
            txtPassword?.layer.borderColor = UIColor.red.cgColor
            
        }
    }
    func setupTargets()
    {
        txtPassword?.addTarget(self, action: #selector(textFieldEditingDidChangePass), for: UIControlEvents.editingChanged)
        txtEmail?.addTarget(self, action: #selector(textFieldEditingDidChangeEmail), for: UIControlEvents.editingChanged)
    }
    func buttonEnabled()
    {
        if (self.boolValidatePass == true && self.boolValidateEmail == true)
        {
            loginBtn?.isEnabled = true
        }
        else
            {
                loginBtn?.isEnabled = false
        }
    }
    @IBAction func emailTextFieldEditing(_ sender: Any) {
    }
    @IBAction func textFieldEditingDidChangeEmail(_ sender: Any) {
        
        if (emailValidator.evaluate(with: txtEmail?.text))
        {
            lblError?.text = "Email Correcto"
            txtEmail?.layer.borderColor = UIColor.green.cgColor
            self.boolValidateEmail = true
        }
        else
        {
            lblError?.text = "Email Incorrecto"
            txtEmail?.layer.borderColor = UIColor.red.cgColor
            
        }
    }
    func loginUserApi(blFinLogin: Bool) {
     alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        if blFinLogin {
            
            print("TRUE")
            let usersVC = UsersViewController()
            navigationController?.pushViewController(usersVC, animated: false)
        }
        else
        {
            
            self.present(self.alert, animated: true)
        }
        
    }
    
    
}
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
var vSpinner: UIView?

class LoginViewController: UIViewController, UITextFieldDelegate, Api {
    
    
    @IBOutlet var txtEmail:YoshikoTextField?
    @IBOutlet var txtPassword:YoshikoTextField?
    @IBOutlet var loginBtn:UIButton?
    @IBOutlet var resetPass:UIButton?
    @IBOutlet var registerBtn:UIButton?
    @IBOutlet var lblError:UILabel?
    @IBOutlet var lblError2:UILabel?
     var boolValidatePass:Bool? = false
    var boolValidateEmail:Bool? = false
    let emailValidator = EmailValidationPredicate()
    let alert:UIAlertController = UIAlertController(title: "Error en tu e-mail o contraseña", message:  "¡Vuelve a intentarlo otra vez!", preferredStyle: UIAlertControllerStyle.actionSheet)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        roundButton()
        setupTargets()
        //buttonEnabled()
        txtEmail?.text = "jo@a.com"
        txtPassword?.text = "qwerty1"
        self.hideKeyboardWhenTappedAround() 
        Auth.auth().addStateDidChangeListener { (auth, user) in
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func resetPAss(_ sender: Any) {
        
    }
    @IBAction func clickLogin(_ sender: UIButton!) {
        
        showSpinner(onView: self.view)
        FirebaseApiManager.sharedInstance.login(email: (txtEmail?.text)!, password: (txtPassword?.text)!, delegate: self)
        
    }
    @IBAction func clickRegister(_ sender: UIButton!) {
        let registerVC = RegisterViewController()
    navigationController?.pushViewController(registerVC, animated: false)
    }
    func roundButton()
    {
        loginBtn?.layer.cornerRadius = 5
        registerBtn?.layer.cornerRadius = 5
        txtEmail?.layer.cornerRadius = 5
        txtPassword?.layer.cornerRadius = 5
        
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
            lblError?.text = ""
            txtPassword?.layer.borderColor = UIColor.green.cgColor
            self.boolValidatePass = true
            }
            else
            {
                lblError2?.text = "Contraseña Invalida,le falta un numero"
                txtPassword?.layer.borderColor = UIColor.red.cgColor
                
            }
        }
        else
        {
            lblError2?.text = "Contraseña debe de ser mas larga de 6"
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
            lblError?.text = ""
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
     
        if blFinLogin {
            
            print("TRUE")
            removeSpinner()
            let usersVC = UsersViewController()
            navigationController?.pushViewController(usersVC, animated: false)
        }
        else
        {
            
            self.present(self.alert, animated: true)
            removeSpinner()
        }
        
    }
    
    
}


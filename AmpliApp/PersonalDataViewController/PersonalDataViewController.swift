//
//  PersonalDataViewController.swift
//  AmpliApp
//
//  Created by Dario Autric on 28/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import UIKit
import TextFieldEffects
import MapKit
import CoreLocation
import FirebaseStorage
import FirebaseFirestore


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {  
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
class PersonalDataViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,MKMapViewDelegate, CLLocationManagerDelegate,Api,UIGestureRecognizerDelegate {
    @IBOutlet var imgUser:UIImageView?
    @IBOutlet var txtName:YoshikoTextField?
    @IBOutlet var txtSurname:YoshikoTextField?
    @IBOutlet var txtDescription:YoshikoTextField?
    @IBOutlet var txtUniversity:YoshikoTextField?
    @IBOutlet var txtJob:YoshikoTextField?
    @IBOutlet var lblError:UILabel?
    @IBOutlet var btnDeleteAccount:UIButton?
    var editProfile:Profile?
    var downloadURL:String?
    let imagePicker = UIImagePickerController()
    var imgData:Data?
    let btnSave = UIButton(type: .custom)
    let btnClose = UIButton(type: .custom)
    let alert:UIAlertController = UIAlertController(title: "Perfil Modificado", message: "¡Has modificado tu perfil", preferredStyle: UIAlertControllerStyle.actionSheet)
    let alert2:UIAlertController = UIAlertController(title: "Profile deleted", message: "¡Thanks for your time!", preferredStyle: UIAlertControllerStyle.actionSheet)
    var userLocation : Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        setUserData()
        roundThings()
        floatingButton()
        imagePicker.delegate = self
        self.hideKeyboardWhenTappedAround()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgUser!.isUserInteractionEnabled = true
        imgUser!.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func deleteUser(_ sender: Any) {
        
        showSpinner(onView: self.view)
        FirebaseApiManager.sharedInstance.delete(user: FirebaseApiManager.sharedInstance.firUser!, delegate: self)
        
    }
    func deleteUser(blFinDelete: Bool) {
        
        if blFinDelete {
            
            print("TRUE")
            removeSpinner()
            let loginVC = LoginViewController()
            navigationController?.pushViewController(loginVC, animated: false)
            self.present(self.alert2, animated: true)
        }
        else
        {
            
            
            removeSpinner()
        }
        
    }
    func updateUser(blFinUpdate: Bool) {
        
        if blFinUpdate {
            
            print("TRUE")
            removeSpinner()
            let usersVC = UsersViewController()
            navigationController?.pushViewController(usersVC, animated: false)
            self.present(self.alert, animated: true)
            
        }
        else
        {
            
            self.present(self.alert, animated: true)
            removeSpinner()
        }
        
    }
    func setUserData()
    {
        if FirebaseApiManager.sharedInstance.miPerfil.sImage == nil {
            FirebaseApiManager.sharedInstance.miPerfil.sImage = "user"
            txtName?.text = FirebaseApiManager.sharedInstance.miPerfil.sName
            if (txtSurname?.text == "") {
                txtSurname?.text = "Surname"
                txtJob?.text = "Job"
                txtDescription?.text = "Description"
                txtUniversity?.text = "University"
            } 
                
        }else {
            
        self.imgUser!.downloaded(from: FirebaseApiManager.sharedInstance.miPerfil.sImage!)
        txtName?.text = FirebaseApiManager.sharedInstance.miPerfil.sName
        txtSurname?.text = FirebaseApiManager.sharedInstance.miPerfil.sSurname
            print(FirebaseApiManager.sharedInstance.miPerfil.sJob)
             print(FirebaseApiManager.sharedInstance.miPerfil.sEmail)
        txtJob?.text = FirebaseApiManager.sharedInstance.miPerfil.sJob
        txtDescription?.text = FirebaseApiManager.sharedInstance.miPerfil.sDescription
        txtUniversity?.text = FirebaseApiManager.sharedInstance.miPerfil.sUniversity
            
   
            
        }
    }
    func floatingButton(){
        
        //Floating button save
        btnSave.frame = CGRect(x: 300, y: 600, width: 50, height: 50)
        btnSave.setImage(UIImage(named: "save") , for: .normal)
        //btnSave.imageView?.contentMode = .scaleAspectFit
        btnSave.contentVerticalAlignment = .fill
        btnSave.contentHorizontalAlignment = .fill
        btnSave.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        btnSave.backgroundColor = UIColor(hexString: "#41AEF6")
        btnSave.clipsToBounds = true
        btnSave.layer.cornerRadius = 25
        btnSave.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnSave.layer.borderWidth = 3.0
        btnSave.addTarget(self,action: #selector(PersonalDataViewController.saveTapped), for: UIControlEvents.touchUpInside)
        view.addSubview(btnSave)
        
        
        btnClose.frame = CGRect(x: 220, y: 600, width: 50, height: 50)
        btnClose.setImage(UIImage(named: "back") , for: .normal)
        btnClose.backgroundColor = UIColor(hexString: "#941100")
        btnClose.clipsToBounds = true
        btnClose.layer.cornerRadius = 25
        btnClose.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnClose.layer.borderWidth = 3.0
        btnClose.addTarget(self,action: #selector(PersonalDataViewController.backTapped), for: UIControlEvents.touchUpInside)
        view.addSubview(btnClose)
        
        btnDeleteAccount?.layer.cornerRadius = 5
        
    }
    @objc func backTapped()   {
        let usersVC = UsersViewController()
        navigationController?.pushViewController(usersVC, animated: false)
    }
    @objc func saveTapped()   {
        showSpinner(onView: self.view)
        FirebaseApiManager.sharedInstance.miPerfil.sName = txtName?.text
        FirebaseApiManager.sharedInstance.miPerfil.sSurname = txtSurname?.text
        FirebaseApiManager.sharedInstance.miPerfil.sDescription = txtDescription?.text
        FirebaseApiManager.sharedInstance.miPerfil.sJob =  txtJob?.text
        FirebaseApiManager.sharedInstance.miPerfil.sUniversity = txtUniversity?.text
        
        
        self.uploadPhoto()
        FirebaseApiManager.sharedInstance.miPerfil.sImage = self.downloadURL
        FirebaseApiManager.sharedInstance.savePerfil(delegate: self)
    }
    func roundThings()
    {
        
        imgUser?.layer.cornerRadius = 40
        imgUser?.layer.masksToBounds=true
        imgUser?.contentMode = .scaleAspectFill
        imgUser?.layer.masksToBounds=true
        imgUser?.layer.borderColor = UIColor.lightGray.cgColor
        imgUser?.layer.borderWidth = 2.0
        
        txtSurname?.layer.borderWidth = 2
        txtSurname?.layer.borderColor = UIColor.lightGray.cgColor
        txtSurname?.layer.cornerRadius = 5
        
        txtName?.layer.borderWidth = 2
        txtName?.layer.cornerRadius = 5
        txtName?.layer.borderColor = UIColor.lightGray.cgColor
        
        txtDescription?.layer.borderWidth = 2
        txtDescription?.layer.cornerRadius = 5
        txtDescription?.layer.borderColor = UIColor.lightGray.cgColor
        
        txtJob?.layer.borderWidth = 2
        txtJob?.layer.cornerRadius = 5
        txtJob?.layer.borderColor = UIColor.lightGray.cgColor
        
        txtUniversity?.layer.borderWidth = 2
        txtUniversity?.layer.cornerRadius = 5
        txtUniversity?.layer.borderColor = UIColor.lightGray.cgColor
    }
    func imageGetMap() -> [String:Any]
    {
        return [
            "image": self.downloadURL as Any
        ]
    }
  
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        self.imgUser?.isUserInteractionEnabled = true
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func uploadPhoto()  {
        let tiempoMilis:Int = Int((Date().timeIntervalSince1970 * 1000.0).rounded())
        let ruta:String = String(format: "imagenes/imagen%d.jpg", tiempoMilis)
        let imagenRef = FirebaseApiManager.sharedInstance.firStorageRef?.child(ruta)
        let metadata =  StorageMetadata()
        metadata.contentType = "image/jpeg"
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = imagenRef?.putData(imgData!, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata
                else {
                    
                    return
            }
            //convertimos la url a string
            if let downloadURL = imagenRef?.downloadURL(completion: {(url, error) in
                if let error = error
                {
                    
                } else {
                    self.downloadURL = (url?.absoluteString)!
                    print("URL descargada = "+self.downloadURL!)
                    FirebaseApiManager.sharedInstance.miPerfil.sImage = self.downloadURL
                    
                   // self.imgUser?.image = UIImage (named: FirebaseApiManager.sharedInstance.miPerfil.sImage!)
                    
               
                    FirebaseApiManager.sharedInstance.firestoreDB?.collection("users").document((FirebaseApiManager.sharedInstance.firUser?.uid)!).updateData(self.imageGetMap())
                    { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        }
                        else
                        {
                            print("Has editado tu foto")
                            FirebaseApiManager.sharedInstance.savePerfil(delegate: self)
                            let reference = Storage.storage().reference(forURL: self.downloadURL!)
                          //  let httpsReference = Storage.storage().reference(forURL: self.downloadURL!)
                            

                            

                        }
                    }
                }
            }){

        }
    }//Esta linea explota
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        // convertimos la imagen a jpg
        imgData = UIImageJPEGRepresentation(img!, 1)!
        imgUser?.image = img
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        
    }
   
    @IBAction func buttonOnClick(_ sender: UIButton)
    {
        
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}

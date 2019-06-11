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
    @IBOutlet var btnBack:UIButton?
    @IBOutlet var btnNext:UIButton?
    @IBOutlet var lblError:UILabel?
    @IBOutlet var btnEdit:UIButton?
    var editProfile:Profile?
    var downloadURL:String?
    let imagePicker = UIImagePickerController()
    var imgData:Data?
    let alert:UIAlertController = UIAlertController(title: "Perfil Modificado", message: "¡Has modificado tu perfil", preferredStyle: UIAlertControllerStyle.actionSheet)
    var userLocation : Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setUserData()
        roundThings()
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
    func setUserData()
    {
        if FirebaseApiManager.sharedInstance.miPerfil.sImage == nil {
            FirebaseApiManager.sharedInstance.miPerfil.sImage = "user"
            txtName?.text = FirebaseApiManager.sharedInstance.miPerfil.sName
            txtSurname?.text = FirebaseApiManager.sharedInstance.miPerfil.sSurname
            txtJob?.text = FirebaseApiManager.sharedInstance.miPerfil.sJob
            txtDescription?.text = FirebaseApiManager.sharedInstance.miPerfil.sDescription
            txtUniversity?.text = FirebaseApiManager.sharedInstance.miPerfil.sUniversity
        }else {
            
        self.imgUser!.downloaded(from: FirebaseApiManager.sharedInstance.miPerfil.sImage!)
        txtName?.text = FirebaseApiManager.sharedInstance.miPerfil.sName
        txtSurname?.text = FirebaseApiManager.sharedInstance.miPerfil.sSurname
        txtJob?.text = FirebaseApiManager.sharedInstance.miPerfil.sJob
        txtDescription?.text = FirebaseApiManager.sharedInstance.miPerfil.sDescription
        txtUniversity?.text = FirebaseApiManager.sharedInstance.miPerfil.sUniversity
            
   
            
        }
    }
    func roundThings()
    {
        btnNext?.layer.cornerRadius = 20
        btnNext?.layer.masksToBounds = true
        btnBack?.layer.cornerRadius = 20
        btnBack?.layer.masksToBounds = true
        imgUser?.layer.cornerRadius = 40
        imgUser?.layer.masksToBounds=true
        imgUser?.contentMode = .scaleAspectFill
        imgUser?.layer.masksToBounds=true
        imgUser?.layer.borderColor = UIColor.blue.cgColor
        imgUser?.layer.borderWidth = 2.0
    }
    func imageGetMap() -> [String:Any]
    {
        return [
            "image": self.downloadURL as Any
        ]
    }
    @IBAction func clickNext(_ sender: Any) {
        
        FirebaseApiManager.sharedInstance.miPerfil.sName = txtName?.text
            FirebaseApiManager.sharedInstance.miPerfil.sSurname = txtSurname?.text
            FirebaseApiManager.sharedInstance.miPerfil.sDescription = txtDescription?.text
            FirebaseApiManager.sharedInstance.miPerfil.sJob =  txtJob?.text
            FirebaseApiManager.sharedInstance.miPerfil.sUniversity = txtUniversity?.text
        
            
        self.uploadPhoto()
        FirebaseApiManager.sharedInstance.miPerfil.sImage = self.downloadURL
        FirebaseApiManager.sharedInstance.savePerfil()
        let vc = UsersViewController()
        navigationController?.pushViewController(vc, animated: false)
        
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
                            FirebaseApiManager.sharedInstance.savePerfil()
                            let reference = Storage.storage().reference(forURL: self.downloadURL!)
                          //  let httpsReference = Storage.storage().reference(forURL: self.downloadURL!)
                            

                            

                        }
                    }
                }
            }){

        }
    }//Esta linea explota
    
    }
        
        
    
    @IBAction func clickBack(_ sender: Any) {
        let vc=UsersViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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

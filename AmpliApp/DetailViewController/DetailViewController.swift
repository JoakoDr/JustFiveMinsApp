//
//  DetailViewController.swift
//  AmpliApp
//
//  Created by Dario Autric on 7/6/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    

    internal var user: Profile?
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var txtLocation: UILabel!
    @IBOutlet weak var txtJob: UILabel!
    @IBOutlet weak var txtUniversity: UILabel!
    @IBOutlet weak var txtAge: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnVolver: UIButton!
    
    convenience init(user2: Profile?)
    {
        self.init()
        self.user = user2
    }
    init() {
        super.init(nibName: "DetailViewController", bundle: nil)
        self.title = NSLocalizedString("Detail Product" , comment: "")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.layer.cornerRadius = 8.0
        viewBack.layer.masksToBounds = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        btnVolver.layer.masksToBounds = true
        txtName.text = user?.sName
        txtAge.text = user?.sBirthday
        txtDescription.text = user?.sDescription
        txtJob.text = user?.sJob
        txtUniversity.text = user?.sUniversity
        if(user?.sLocation?.sCity == nil)
        {
            txtLocation.text = "No Location"
        } else {
            txtLocation.text = user?.sLocation?.sCity
        }
        
        print(user?.sLocation?.sCountry)
        if(user?.sImage == nil)
        {
            img.image = UIImage(named: "user")
        } else {
            img!.downloaded(from: (user?.sImage)!)
        }
       /* if (img.downloaded(from: (user?.sImage)!) != nil)
        {
            img.downloaded(from: (user?.sImage)!)
        }
        else {
            print("Error en la bajada")
        }
        */
        //img.image = UIImage(named: (user?.sImage)!)
        //UIImage(named: (user?.sImage)!)
        //roundImage()
        // Do any additional setup after loading the view.
    }
    func roundImage()
    {
        img.layer.borderWidth = 1
        img.layer.masksToBounds = false
        img.layer.borderColor = UIColor.black.cgColor
        img.layer.cornerRadius = img.frame.height/2
        img.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.8) {
            self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closeButtonPressed()
    {
       self.dismiss(animated: true, completion: nil)
        
    }
    
    
}



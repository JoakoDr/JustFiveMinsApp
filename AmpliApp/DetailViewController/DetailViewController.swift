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
    @IBOutlet weak var txtBrand: UILabel!
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
        
        
        
        btnVolver.layer.masksToBounds = true
        txtName.text = user?.sName
        txtBrand.text = user?.sLocation?.sCountry
       // img.image = UIImage(named: (user?.photo)!)
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
        dismiss(animated: true, completion: nil)
        
    }
    
    
}



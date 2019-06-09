//
//  UsersViewController.swift
//  AmpliApp
//
//  Created by Dario Autric on 9/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import UIKit
import FirebaseAuth


extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

class UsersViewController: UIViewController, Api {
    
    var sidebarView: SideBarMenu!
    var blackScreen: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var arrUsers = (FirebaseApiManager.sharedInstance.arUsers)
    var img:String?
    
    var arColorFilters:[UIColor] = [UIColor(hexString: "#56FF9800") ,UIColor(hexString: "#1565C0") ,UIColor(hexString: "#D81B60") ,UIColor(hexString: "#00695C"),UIColor(hexString: "#ab47bc") ,UIColor(hexString: "#C62828") ]
    var arUsersFiltered:[String] = []

    convenience init(img: String?)
    {
        self.init()
        self.img = img
        
    }
    init() {
        super.init(nibName: "UsersViewController", bundle: nil)
        self.title = NSLocalizedString("Home" , comment: "")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        FirebaseApiManager.sharedInstance.getUserData(delegate: self)
        setupImageAppBar()
        setupSideBar()
        //noShowScroll()
        
        
    }
    
    
    func setupSideBar()
    {
        sidebarView=SideBarMenu(frame: CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height))
        sidebarView.delegate=self
        sidebarView.layer.zPosition=100
        self.view.isUserInteractionEnabled=true
        self.navigationController?.view.addSubview(sidebarView)
        
        
        blackScreen=UIView(frame: self.view.bounds)
        blackScreen.backgroundColor=UIColor(white: 0, alpha: 0.5)
        blackScreen.isHidden=true
        self.navigationController?.view.addSubview(blackScreen)
        blackScreen.layer.zPosition=99
        let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(blackScreenTapAction(sender:)))
        blackScreen.addGestureRecognizer(tapGestRecognizer)
    }
     func setupImageAppBar()
    {
        //setup color of the bar
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#1E88E5")
        //create a new button
        let menuButton: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        menuButton.setImage(UIImage(named: "menu"), for: [])
        //set Action
        menuButton.addTarget(self, action: #selector(UsersViewController.btnMenuAction), for: UIControlEvents.touchUpInside)
        let barButtonMenu = UIBarButtonItem(customView: menuButton)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButtonMenu
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func noShowScroll()
    {
        collectionView.showsHorizontalScrollIndicator = false
    }
    @objc func btnMenuAction() {
        blackScreen.isHidden=false
        UIView.animate(withDuration: 0.3, animations: {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 250, height: self.sidebarView.frame.height)
        }) { (complete) in
            self.blackScreen.frame=CGRect(x: self.sidebarView.frame.width, y: 0, width: self.view.frame.width-self.sidebarView.frame.width, height: self.view.bounds.height+100)
        }
    }
    
    @objc func blackScreenTapAction(sender: UITapGestureRecognizer) {
        blackScreen.isHidden=true
        blackScreen.frame=self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
    }
    internal func registerCells(){
        let nib = UINib(nibName: "FilterCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "filterCell")
        
    }
    func getUserDataApi(blFin: Bool) {
        if(blFin)
        {
            
            print("me he descargado datosssss")
        }else {
            print("error")
        }
    }
    
    
}
extension UsersViewController: SidebarViewDelegate {
    func sidebarDidSelectRow(row: Row) {
        blackScreen.isHidden=true
        blackScreen.frame=self.view.bounds
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame=CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
        }
        switch row {
        case .photo:
            print("userphoto")
        case .home:
            let vc=LocationViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .messages:
            print("Messages")
        case .addlocation:
            print("Contact")
            let vc=MapViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .friends:
            print("Friends")
            let vc=FriendsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .myphotos:
            print("Photos")
            let vc=PhotosViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .personaldata:
            print("Personal AData")
            let vc=PersonalDataViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .contactus:
            print("Contact Us")
        case .closesession:
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true, completion: nil)
                let vc=LoginViewController()
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            } catch let err {
                print(err)
            }
            print("Close session")
        case .none:
            print("none")
       
        }
    }
}
extension UsersViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
            
            return FirebaseApiManager.sharedInstance.arFilters.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCollectionViewCell
            // Set up cell
            
            cellA.filterName?.text = FirebaseApiManager.sharedInstance.arFilters[indexPath.row].categoryTitle
            cellA.iconImg?.image = UIImage(named: FirebaseApiManager.sharedInstance.arFilters[indexPath.row].categoryImg!)
            cellA.layer.borderColor = UIColor.lightGray.cgColor
            cellA.layer.backgroundColor = self.arColorFilters[indexPath.row].cgColor
            cellA.layer.cornerRadius = 6
            cellA.layer.borderWidth = 1.0
            cellA.layer.shadowColor = UIColor.gray.cgColor
            cellA.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cellA.layer.shadowRadius = 2.0
            cellA.layer.shadowOpacity = 1.0
            cellA.layer.masksToBounds = false
            cellA.layer.shadowPath = UIBezierPath(roundedRect:cellA.bounds, cornerRadius:cellA.contentView.layer.cornerRadius).cgPath
            return cellA
        
        
            }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = collectionView.cellForItem(at: indexPath)
        
            let cell = collectionView.cellForItem(at: indexPath)
            var cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCollectionViewCell
            cellA = cell as! FilterCollectionViewCell
            cellA.layer.borderColor = UIColor.black.cgColor
            FirebaseApiManager.sharedInstance.categorySelected = FirebaseApiManager.sharedInstance.arrFilterCategory[indexPath.row]
        let vc=FilterViewController(arr: (FirebaseApiManager.sharedInstance.categorySelected?.arrUsers ?? nil)!)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        _ = collectionView.cellForItem(at: indexPath)
        
        
    }
}



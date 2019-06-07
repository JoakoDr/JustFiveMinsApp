//
//  UsersViewController.swift
//  AmpliApp
//
//  Created by Dario Autric on 9/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import UIKit
import FirebaseAuth

class UsersViewController: UIViewController, Api {
    var sidebarView: SideBarMenu!
    var blackScreen: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewB: UICollectionView!
    var arrUsers = (FirebaseApiManager.sharedInstance.arUsers)
    
    var arColorFilters:[CGColor] = [UIColor.orange.cgColor,UIColor.blue.cgColor,UIColor.red
        .cgColor,UIColor.green.cgColor,UIColor.purple.cgColor,UIColor.black.cgColor]
    var arUsersFiltered:[String] = []

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
        navigationController?.navigationBar.barTintColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
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
    func paddingLayoutCell(){
        let layout = self.collectionViewB.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
        layout.itemSize = CGSize(width: (self.collectionViewB.frame.size.width - 20)/2, height: (self.collectionViewB.frame.size.height - 20)/3)
    }
    func noShowScroll()
    {
        collectionView.showsHorizontalScrollIndicator = false
        collectionViewB.showsVerticalScrollIndicator = false
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
        
        let nib2 = UINib(nibName: "UsersCollectionViewCell", bundle: nil)
        collectionViewB.register(nib2, forCellWithReuseIdentifier: "userCell")
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
        if collectionView == self.collectionView {
            
            return FirebaseApiManager.sharedInstance.arFilters.count
        }
        
        
        return (FirebaseApiManager.sharedInstance.categorySelected?.arrUsers.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCollectionViewCell
            // Set up cell
            
            cellA.filterName?.text = FirebaseApiManager.sharedInstance.arFilters[indexPath.row].categoryTitle
            cellA.layer.borderColor = UIColor.lightGray.cgColor
            cellA.layer.backgroundColor = self.arColorFilters[indexPath.row]
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
            let user = FirebaseApiManager.sharedInstance.categorySelected?.arrUsers[indexPath.row]
            
            //if is filtered is true change the border color lf the cell
            if (FirebaseApiManager.sharedInstance.isFiltered(user: user))
            {
                
                let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UsersCollectionViewCell
                
                
                
                cellB.userName?.text = FirebaseApiManager.sharedInstance.arUsers[indexPath.row].sName
                cellB.userAge?.text = FirebaseApiManager.sharedInstance.arUsers[indexPath.row].sBirthday
                cellB.layer.borderColor = UIColor.lightGray.cgColor
                cellB.layer.cornerRadius = 6
                cellB.layer.borderWidth = 1.0
                cellB.layer.shadowColor = UIColor.gray.cgColor
                cellB.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                cellB.layer.shadowRadius = 2.0
                cellB.layer.shadowOpacity = 1.0
                cellB.layer.masksToBounds = false
                cellB.layer.shadowPath = UIBezierPath(roundedRect:cellB.bounds, cornerRadius:cellB.contentView.layer.cornerRadius).cgPath
                return cellB
                
            } else {
                
                let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UsersCollectionViewCell
                
                
                
                cellB.userName?.text = FirebaseApiManager.sharedInstance.arUsers[indexPath.row].sName
                cellB.userAge?.text = FirebaseApiManager.sharedInstance.arUsers[indexPath.row].sBirthday
                cellB.layer.borderColor = UIColor.lightGray.cgColor
                cellB.layer.cornerRadius = 6
                cellB.layer.borderWidth = 1.0
                cellB.layer.shadowColor = UIColor.gray.cgColor
                cellB.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                cellB.layer.shadowRadius = 2.0
                cellB.layer.shadowOpacity = 1.0
                cellB.layer.masksToBounds = false
                cellB.layer.shadowPath = UIBezierPath(roundedRect:cellB.bounds, cornerRadius:cellB.contentView.layer.cornerRadius).cgPath
                return cellB
                
                }
            
            }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = collectionView.cellForItem(at: indexPath)
        if collectionView == self.collectionView {
            let cell = collectionView.cellForItem(at: indexPath)
            var cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCollectionViewCell
            cellA = cell as! FilterCollectionViewCell
            cellA.layer.borderColor = UIColor.black.cgColor
            FirebaseApiManager.sharedInstance.categorySelected = FirebaseApiManager.sharedInstance.arrFilterCategory[indexPath.row]
            collectionViewB.reloadData()
        } else if collectionView == self.collectionViewB{
            
            print("Has pulsado en una celda "+(FirebaseApiManager.sharedInstance.categorySelected?.arrUsers[indexPath.row].sName)!)
            let myUser = FirebaseApiManager.sharedInstance.categorySelected?.arrUsers[indexPath.row]
            let addView = DetailViewController(user2: myUser)
            addView.modalTransitionStyle = .coverVertical
            addView.modalPresentationStyle = .overCurrentContext
            present(addView,animated: true,completion: nil)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        _ = collectionView.cellForItem(at: indexPath)
        
        
    }
}


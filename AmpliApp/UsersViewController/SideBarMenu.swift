//
//  SideBarMenu.swift
//  AmpliApp
//
//  Created by Dario Autric on 5/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import Foundation
import UIKit

protocol SidebarViewDelegate: class {
    func sidebarDidSelectRow(row: Row)
}

enum Row: String {
    case photo
    case home
    case messages
    case addlocation
    case friends
    case myphotos
    case personaldata
    case contactus
    case closesession
    case none
    
    init(row: Int) {
        switch row {
        case 0: self = .photo
        case 1: self = .home
        case 2: self = .messages
        case 3: self = .addlocation
        case 4: self = .friends
        case 5: self = .myphotos
        case 6: self = .personaldata
        case 7: self = .contactus
        case 8: self = .closesession
        default: self = .none
        }
    }
}

class SideBarMenu: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var titleArr = [String]()
    
    weak var delegate: SidebarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        self.clipsToBounds=true
        
        titleArr = ["Joaquin Diaz", "Home", "Messages", "Add Location", "Friends", "My Photos", "Personal Data", "Contact us", "Close Session"]
        
        setupViews()
        
        
        myTableView.delegate=self
        myTableView.dataSource=self
        registerCells()
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.tableFooterView=UIView()
        myTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        myTableView.allowsSelection = true
        myTableView.bounces=false
        myTableView.showsVerticalScrollIndicator=false
        myTableView.backgroundColor = UIColor.clear
        if let index = self.myTableView.indexPathForSelectedRow{
            self.myTableView.deselectRow(at: index, animated: true)
        }
        
    }
    private func registerCells ()
    {
        let indentifier = "MenuTableViewCell"
        let cellNib = UINib(nibName: indentifier, bundle: nil)
        myTableView.register(cellNib, forCellReuseIdentifier: "menuCell")
        
        let indentifier1 = "MenuLocationTableViewCell"
        let cellNib1 = UINib(nibName: indentifier1, bundle: nil)
        myTableView.register(cellNib1, forCellReuseIdentifier: "usernameCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellA=tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        if indexPath.row == 0 {
            
            cellA.backgroundColor = .clear
            
            cellA.selectionStyle = .none
            cellA.backgroundColor=UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1.0)
            let cellImg: UIImageView!
            cellImg = UIImageView(frame: CGRect(x: 15, y: 20, width: 80, height: 80))
            cellImg.layer.cornerRadius = 40
            cellImg.layer.masksToBounds=true
            cellImg.contentMode = .scaleAspectFill
            cellImg.layer.masksToBounds=true
            cellImg.image=UIImage(named: "user")
            cellA.addSubview(cellImg)
           // var myUserName:UITextfield = UITextField(frame: CGRect(x: 60, y: 20, width: 40, height: 20))
            cellA.titleLbl?.text = FirebaseApiManager.sharedInstance.miPerfil.sName
            cellA.titleLbl?.drawText(in: CGRect(x: 60, y: 10, width: 40, height: 20))
            cellA.titleLbl?.textColor = UIColor.white
            
        } else if indexPath.row == 1 {
        
            cellA.titleLbl?.text=titleArr[indexPath.row]
            cellA.titleLbl?.textColor=UIColor.black
            cellA.icon?.image = UIImage(named: "home")
            
            return cellA
            
        }
        else if indexPath.row == 2 {
            
            cellA.titleLbl?.text=titleArr[indexPath.row]
            cellA.titleLbl?.textColor=UIColor.black
            cellA.icon?.image = UIImage(named: "chat")
            
            return cellA
            
        }
        else if indexPath.row == 3 {
            
            cellA.titleLbl?.text=titleArr[indexPath.row]
            cellA.titleLbl?.textColor=UIColor.black
            cellA.icon?.image = UIImage(named: "location")
            
            return cellA
            
        }
        else if indexPath.row == 4 {
            
            cellA.titleLbl?.text=titleArr[indexPath.row]
            cellA.titleLbl?.textColor=UIColor.black
            cellA.icon?.image = UIImage(named: "friends")
            
            return cellA
            
            
        }
        else if indexPath.row == 5 {
            
            cellA.titleLbl?.text=titleArr[indexPath.row]
            cellA.titleLbl?.textColor=UIColor.black
            cellA.icon?.image = UIImage(named: "photos")
            
            return cellA
            
        }
        else if indexPath.row == 6 {
            
            cellA.titleLbl?.text=titleArr[indexPath.row]
            cellA.titleLbl?.textColor=UIColor.black
            cellA.icon?.image = UIImage(named: "data")
            
            return cellA
            
        }
        else if indexPath.row == 7 {
            
            cellA.titleLbl?.text=titleArr[indexPath.row]
            cellA.titleLbl?.textColor=UIColor.black
            cellA.icon?.image = UIImage(named: "contact")
            
            return cellA
            
        }
        else if indexPath.row == 8 {
            
            cellA.titleLbl?.text=titleArr[indexPath.row]
            cellA.titleLbl?.textColor=UIColor.black
            cellA.icon?.image = UIImage(named: "close")
            
            return cellA
            
            
        }
       
        return cellA
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.sidebarDidSelectRow(row: Row(row: indexPath.row))
        myTableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        } else {
            return 55
        }
    }
    
    
    func setupViews() {
        self.addSubview(myTableView)
        myTableView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        myTableView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        myTableView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        myTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let myTableView: UITableView = {
        let table=UITableView()
        table.translatesAutoresizingMaskIntoConstraints=false
        return table
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


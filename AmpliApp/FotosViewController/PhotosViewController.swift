//
//  PhotosViewController.swift
//  AmpliApp
//
//  Created by JOAQUIN DIAZ RAMIREZ on 15/1/19.
//  Copyright © 2019 JOAQUIN DIAZ RAMIREZ. All rights reserved.
//

import UIKit
class PhotosViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewB: UICollectionView!
    
    
    init() {
        super.init(nibName: "PhotosViewController", bundle: nil)
        self.title = NSLocalizedString("My Photos" , comment: "")
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpButtonAppBar()
        registerCells()
        notScrollBar()
        paddingLayoutCell()
        // Do any additional setup after loading the view.
    }
    
    func paddingLayoutCell(){
        let layout = self.collectionViewB.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0)
        layout.itemSize = CGSize(width: (self.collectionViewB.frame.size.width - 20)/2, height: (self.collectionViewB.frame.size.height - 20)/3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func notScrollBar()
    {
        collectionView.showsHorizontalScrollIndicator = false
        collectionViewB.showsVerticalScrollIndicator = false
    }
    
    func setUpButtonAppBar()
    {
       /*
        let homeButton: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        homeButton.setImage(UIImage(named: "home"), for: [])
        //set Action
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: UIControlEvents.touchUpInside)
        let barButtonHome = UIBarButtonItem(customView: homeButton)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButtonHome
 */
    }
    internal func registerCells(){
        let nib = UINib(nibName: "UsersCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "userCell")
        
        let nib3 = UINib(nibName: "UsersCollectionViewCell", bundle: nil)
        collectionViewB.register(nib3, forCellWithReuseIdentifier: "userCell")
    }
    
   
   
    
}


extension PhotosViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return 1
        }
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //if to setup both collections view with diferent cells
        if collectionView == self.collectionView {
            
            
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UsersCollectionViewCell
            cellA.userName?.text = "Joaquin"
            cellA.userImg?.image = nil
            // Set up cell
            return cellA
        }
        let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UsersCollectionViewCell
        cellA.userName?.text = "Joaquin"
        cellA.userImg?.image = nil
        // Set up cell
        return cellA
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Hola")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        _ = collectionView.cellForItem(at: indexPath)
        
    }
}

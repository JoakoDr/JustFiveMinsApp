//
//  FriendsViewController.swift
//  AmpliApp
//
//  Created by Dario Autric on 10/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var usersTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()

        // Do any additional setup after loading the view.
    }
    init() {
        super.init(nibName: "FriendsViewController", bundle: nil)
        self.title = NSLocalizedString("Friends" , comment: "")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    internal func registerCells(){
        let nib = UINib(nibName: "FriendsTableViewCell", bundle: nil)
        usersTableView.register(nib, forCellReuseIdentifier: "friendsCell")
        
    }

}

extension FriendsViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.imageView?.image = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Has pulsado en el index:")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        
    }
}

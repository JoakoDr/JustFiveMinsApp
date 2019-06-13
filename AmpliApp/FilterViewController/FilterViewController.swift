import UIKit
//import MaterialComponents.MaterialButtons
//import MaterialComponentsBeta.MaterialButtons_Theming

class FilterViewController: UIViewController {
    var arrFilterUsers: [Profile?] = []
    let btn = UIButton(type: .custom)
    @IBOutlet weak var filterCV: UICollectionView!
    //let floatingButton = MDCFloatingButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        registerCells()
        //setupFloating()
        floatingButton()
        // Do any additional setup after loading the view.
    }
    
    
    convenience init(arr: [Profile]) {
        self.init()
        arrFilterUsers = arr
    }
    
    internal func registerCells(){
        let nib = UINib(nibName: "UsersCollectionViewCell", bundle: nil)
        filterCV.register(nib, forCellWithReuseIdentifier: "userCell")
        
    }
    func floatingButton(){
        
        btn.frame = CGRect(x: 300, y: 600, width: 50, height: 50)
        btn.setImage(UIImage(named: "back") , for: .normal)
        btn.backgroundColor = UIColor(hexString: "#941100")
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 25
        btn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn.layer.borderWidth = 3.0
        btn.addTarget(self,action: #selector(FilterViewController.backTapped), for: UIControlEvents.touchUpInside)
        view.addSubview(btn)
    }
    @objc func backTapped()   {
        let usersVC = UsersViewController()
        navigationController?.pushViewController(usersVC, animated: false)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let  off = self.filterCV.contentOffset.y
        
        btn.frame = CGRect(x: 285, y:   off + 485, width: btn.frame.size.width, height: btn.frame.size.height)
    }
}
extension FilterViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return arrFilterUsers.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UsersCollectionViewCell
        // Set up cell
        
        cellA.userName?.text = self.arrFilterUsers[indexPath.row]?.sName
        cellA.userCountry?.text = self.arrFilterUsers[indexPath.row]?.sBirthday
        cellA.viewLabel?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        if(arrFilterUsers[indexPath.row]?.sImage == nil)
        {
            cellA.userImg?.image = UIImage(named: "user")
        } else {
            cellA.userImg?.downloaded(from: (arrFilterUsers[indexPath.row]?.sImage)!)
        }
        
        
        
        cellA.layer.borderColor = UIColor.lightGray.cgColor
        // cellA.layer.backgroundColor = self.arColorFilters[indexPath.row].cgColor
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
        let user = self.arrFilterUsers[indexPath.row]
        let registerVC = DetailViewController(user2: user)
        present(registerVC, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        _ = collectionView.cellForItem(at: indexPath)
        
        
    }
}


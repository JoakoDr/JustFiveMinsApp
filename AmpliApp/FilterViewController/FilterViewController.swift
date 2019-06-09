import UIKit
//import MaterialComponents.MaterialButtons
//import MaterialComponentsBeta.MaterialButtons_Theming

class FilterViewController: UIViewController {
    var arrFilterUsers: [Profile?] = []
    @IBOutlet weak var filteredCollectionView: UICollectionView!
    //let floatingButton = MDCFloatingButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        //setupFloating()
        // Do any additional setup after loading the view.
    }
    
    
    convenience init(arr: [Profile]) {
        self.init()
        arrFilterUsers = arr
    }
    
    internal func registerCells(){
        let nib = UINib(nibName: "UsersCollectionViewCell", bundle: nil)
        filteredCollectionView.register(nib, forCellWithReuseIdentifier: "userCell")
        
    }
    /*
    func setupFloating()
    {
        //floatingButton.applySecondaryTheme(withScheme: containerScheme)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let  off = self.filteredCollectionView.contentOffset.y
        
        btnBack.frame = CGRect(x: 285, y:   off + 485, width: btnBack.frame.size.width, height: btnBack.frame.size.height)
    }
    */
}
extension FilterViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return arrFilterUsers.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UsersCollectionViewCell
        // Set up cell
        
        cellA.userName?.text = self.arrFilterUsers[indexPath.row]?.sName
        cellA.userAge?.text = self.arrFilterUsers[indexPath.row]?.sBirthday
        //cellA.iconImg?.image = UIImage(named: FirebaseApiManager.sharedInstance.arFilters[indexPath.row].categoryImg!)
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
        navigationController?.pushViewController(registerVC, animated: false)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        _ = collectionView.cellForItem(at: indexPath)
        
        
    }
}


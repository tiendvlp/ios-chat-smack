import UIKit


class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var btnChangeBackground: UISegmentedControl!
    @IBOutlet weak var collectionAvatar: UICollectionView!
    
    @IBOutlet weak var btnSegmentChooseBackground: UISegmentedControl!
    private var currentCellBackground : AvatarBackground = AvatarBackground.light
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AVATAR_COLLECTION_CELL_IDENTIFIER, for: indexPath) as? AvatarCollectionViewCell {
                cell.setup(currentCellBackground, indexPath.row)
            return cell
        } else {
            let cell = AvatarCollectionViewCell()
            return cell
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    override func viewDidLoad() {
        self.collectionAvatar.dataSource = self
        self.collectionAvatar.delegate = self
        
    }
    
    @IBAction func onBtnBackClickedListener(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onBtnChangeBackgroundChangedListener(_ sender: Any) {
        switch btnSegmentChooseBackground.selectedSegmentIndex {
        case 0 : self.currentCellBackground = AvatarBackground.light; break
        case 1 : self.currentCellBackground = AvatarBackground.dark; break
        
        default:
            break
        }
        
        collectionAvatar.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item clicked \(indexPath.row)")
        
        if currentCellBackground == .dark {
            UserDataService.instance.avatarName = "dark\(indexPath.row)"
        } else {
            UserDataService.instance.avatarName = "light\(indexPath.row)" 
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numOfColumns : CGFloat = 3
        
        // 320 this is ip 5 screen
        if (UIScreen.main.bounds.width > 320) {
            numOfColumns = 4
            print("num of columns is \(numOfColumns)")
        }
        // calculate the demension of each cell
        
        let total_padding_left_and_right : CGFloat = 30
        let spacebetweenRow : CGFloat = 10
        
        let cellDemension : CGFloat = ((collectionView.bounds.width - total_padding_left_and_right) - (numOfColumns - 1)*spacebetweenRow) / (numOfColumns+1)
        
        print("demension of cell is \(cellDemension)")
        
        return CGSize(width: cellDemension , height: cellDemension)
    }
}

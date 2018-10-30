//
//  StoreViewController.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 27/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import UIKit
import SVProgressHUD
import Hero


/// Structure for handle collapse and expand table view cell, items Array
struct ExpandableItems {
    var isExpanded : Bool
    let items : [Item]
}

/// StoreViewController Handle the following
///   * Category Items API  call
///   * downlad items images - sdweb image
///   * go to corresponding itemVC on item selection
class StoreViewController: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var navigationTitleView: UIView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var navigationVwTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var storeTableView: UITableView!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var minOrdAmountLable: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    
    //MARK: - IBActions
    @IBAction func infoButtonTapped(_ sender: Any) {
        self.infoButton.isHidden = true
        UIView.animate(withDuration: 0.8, animations: {
            self.infoStackView.alpha = 1.0
        })
//        self.setView(view: infoStackView, hidden: false)
    }
    
    //MARK: - VC Variables
    var menuArray = [Category]()
    var storeInfo : Store?
    var itemsArray: [ExpandableItems] = []
    
    var selectedIndexPath = IndexPath()
    var selectedItemImage = UIImage()
    
    var storeImage : UIImage?
}

//MARK: - Life cycles
extension StoreViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UpdateView(tableView: storeTableView)
        
        self.navigationVwTopConstraint.constant = -70
        self.infoStackView.alpha = 0
        
        self.startLoader()
        self.initialiseValues()
        
        getItemsInfo_API()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.storeTableView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
     /// Delegate to handle navigation view hide and show for table view scrolling
     ///
     /// - Parameter scrollView: scroll view
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.Setupnewview(tableView: self.storeTableView)
        }
//        print("tableVw content offset : \(storeTableView.contentOffset)")
        if storeTableView.contentOffset.y >= -5 {
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationVwTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationVwTopConstraint.constant = -70
                self.view.layoutIfNeeded()
            })
        }
        
    }
}

//MARK: - Table View Functionalities
extension StoreViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuArray.count + 1 // count = Number of Menu + 1 Menu title cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1 //Menu Title cell
        }
        else {
            let expandableItem = itemsArray[section - 1]
            if expandableItem.isExpanded {
                let item = expandableItem.items
                return item.count + 1 // 1 Menu name cell + item count for menu
            }
            else {
                return 1 // Menu Name cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Menu Title Cell
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell_Ids.MENU_TITLE_CELL.rawValue, for: indexPath) as! MenuTitle_TV_Cell
            guard let workingHr = storeInfo?.workingHour  else { return cell }
            cell.workingHourLabel.text = workingHr
            return cell
        }
        else  {
            let menuObj = menuArray[(indexPath.section) - 1]
            if indexPath.row == 0 {
                //Menu Name cell
                return setMenuNameTitleCell(tableView, indexPath, menuObj)
            }
            else {
                //Items Detail cell
                return setItemDetailsCell(tableView, indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            if indexPath.row == 0 {
                //Tapping menu name cell
                self.handleCollapseExpand(indexPath: indexPath)
            }
            else {
                //Tapping item cell
                selectedIndexPath = indexPath
                let cell = tableView.cellForRow(at: indexPath) as! ItemDetail_TV_Cell
                selectedItemImage = cell.itemImageView.image!
                self.showItemVC ()
            }
        }
    }
    
    /// set Menu Name title cell for tableview
    ///
    /// - Parameters:
    ///   - tableView: table view name
    ///   - indexPath: indexPath of cell
    ///   - menuObj: Category
    /// - Returns: MenuNameTitle_TV_Cell
    fileprivate func setMenuNameTitleCell(_ tableView: UITableView, _ indexPath: IndexPath, _ menuObj: Category) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell_Ids.MENU_TITLE_NAME_CELL.rawValue, for: indexPath) as! MenuNameTitle_TV_Cell
        cell.menuNameLabel.text = menuObj.menuName_eng
        cell.isCollapsedIndicatorVw.isHidden = true
        cell.seperatorView.isHidden = false
        return cell
    }
    
    
    /// set Item Detail cell for tableview
    ///
    /// - Parameters:
    ///   - tableView: tableview name
    ///   - indexPath: indexpath of cell
    /// - Returns: ItemDetail_TV_Cell
    fileprivate func setItemDetailsCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell_Ids.ITEM_DETAIL_CELL.rawValue, for: indexPath) as! ItemDetail_TV_Cell
        let item = itemsArray[(indexPath.section) - 1].items
        let itemObj = item[indexPath.row - 1]
        cell.itemNameLabel.text = itemObj.itemName_eng
        cell.itemDescription.text = itemObj.itemDesc_eng
        cell.itemPriceLabel.text = itemObj.itemPrice! + " " + self.currencyString
        
        cell.itemImageView.loadImageFromUrl(urlString: itemObj.itemImage!)
        
        cell.itemImageView.hero.id = "\(indexPath)_image"
        cell.itemNameLabel.hero.id = "\(indexPath)_label"
        cell.itemDescription.hero.id = "\(indexPath)_description"
        return cell
    }
    
    
}

//MARK: - Functionalities
extension StoreViewController {
    
    
    /// API call to get items info
    func getItemsInfo_API() {
        let storeInfoURL = "https://www.jeebleybeta.com/services_new/services.php?action=menuCategories&rId=366&cuisineType=1&countryId=21&langId=1"
        apiCall(url: storeInfoURL)
    }
    
    
    /// loader for API call : start
    func startLoader () {
        self.view.isUserInteractionEnabled = false
        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.show()
    }
    
    /// loader for API call : end
    func endLoader() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
        }
    }
    
    
    /// function to reload storeVC table with updated API values
    func reloadTableView() {
        fetchfromDB_category()
        DispatchQueue.main.async {
            self.storeTableView.reloadData()
        }
    }
    
    
    /// DB fetching Category information
    func fetchfromDB_category() {
        menuArray.removeAll()
        itemsArray.removeAll()
        let categoryList = DBEntityHelpers().fetchCategoryEntity()
        for menu in categoryList {
            menuArray.append(menu)
            if let items = menu.items?.allObjects as? [Item] {
                let expandableItem = ExpandableItems(isExpanded: false, items: items)
                itemsArray.append(expandableItem)
            }
        }
    }
    
    
    /// Handling collapse expand on Menu selection
    ///
    /// - Parameter indexPath: indexpath of menu
    func handleCollapseExpand(indexPath:IndexPath) {
        var indexPaths = [IndexPath]()
        
        let itemsCount = itemsArray[indexPath.section - 1].items.count + 1
        for row in 1 ..< itemsCount {
            let indexP = IndexPath(row: row, section: indexPath.section)
            indexPaths.append(indexP)
        }
        
        let isExpanded = itemsArray[indexPath.section - 1].isExpanded
        itemsArray[indexPath.section - 1].isExpanded = !isExpanded
        
        let _indexPath = IndexPath(row: 0, section: indexPath.section)
        let cell:MenuNameTitle_TV_Cell = storeTableView.cellForRow(at: _indexPath) as! MenuNameTitle_TV_Cell
        if !isExpanded {
            cell.isCollapsedIndicatorVw.isHidden = false
            cell.seperatorView.isHidden = true
            storeTableView.insertRows(at: indexPaths, with: .fade)
        }
        else {
            cell.isCollapsedIndicatorVw.isHidden = true
            cell.seperatorView.isHidden = false
            storeTableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    
    
    /// Initialise VC Values
    func initialiseValues() {
//        let storeList = DBEntityHelpers().fetchStoreEntity()
//        self.storeInfo = storeList[0]
        
        self.currencyString = (storeInfo?.cntrCurrency!)!
        if let storeimage = self.storeImage {
            self.storeImageView.image = storeimage
        }
        self.navigationTitleLabel.text = storeInfo?.rName
        self.storeNameLabel.text = storeInfo?.rName
        self.minOrdAmountLable.text = (storeInfo?.rMinOrderAmt!)! + " " + currencyString
        self.averageLabel.text = storeInfo?.rDeliveryTime!
        self.deliveryFeeLabel.text = (storeInfo?.rDeliveryCharge!)! + " " +  currencyString
    }
    
    
    /// Perform Segue to itemVC
    func showItemVC() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: SegueIds.STORE_ITEM.rawValue, sender: self)
        }
    }
    
    
    /// Action after API call
    ///
    /// - Parameter data: data recieved from API call
    func apiResponseActions (data:Data?) {
        guard let data = data else { return }

        do {
            print(data)
            let categoryInfo = try JSONDecoder().decode(CategoryArray.self, from: data)

            guard let _categoryInfo = categoryInfo.categoryArray else { return }

            DBEntityHelpers().saveToDB(categoryInfoObj: _categoryInfo)
            self.reloadTableView()
            self.endLoader()

        }
        catch let jsonErr {
            print("jsonErr :: \(jsonErr)")
        }
    }
    
    
    /// Common Api Call Function
    ///
    /// - Parameter url: URL for API call
    func apiCall (url : String) {
        let service = Service()
        service.setConfigUrl(url)
        service.execute{ (data, action, serviceStatus) in
            if serviceStatus == ServiceStatus.FAILED.rawValue {
                self.showAlert(title: "", message: action)
            }
            else {
                self.apiResponseActions(data: data)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIds.STORE_ITEM.rawValue {
            let itemVC = segue.destination as! ItemViewController
            let item = itemsArray[(selectedIndexPath.section) - 1].items
            let itemObj = item[selectedIndexPath.row - 1]
            
            //passing values to itemVC
            itemVC.item = itemObj
            itemVC.itemImage = selectedItemImage
            itemVC.heroId_image = "\(selectedIndexPath)_image"
            itemVC.heroId_label = "\(selectedIndexPath)_label"
            itemVC.heroId_description = "\(selectedIndexPath)_description"
        }
    }
}



//
//  StoreTableViewController.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 28/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import UIKit
import SVProgressHUD


//struct ExpandableItems {
//    var isExpanded : Bool
//    let items : [Item]
//}

class StoreTableViewController: UITableViewController {

    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var minOrdAmountLable: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        self.infoButton.isHidden = true
        self.setView(view: infoStackView, hidden: false)
    }
    
    var Headerview : UIView!
    var NewHeaderLayer : CAShapeLayer!
    
    private let Headerheight : CGFloat = 225
    private let Headercut : CGFloat = 0
    
    let currencyString = "KD"
    
    var menuArray = [Category]()
    var storeInfo = Store()
    var itemsCountForMenu: [Category: Int] = [:]
    var itemsForMenu: [Category: [Item]] = [:]
    
//    var itemsArray: [[Item]] = []
    var itemsArray: [ExpandableItems] = []
}

//MARK: - Life cycles
extension StoreTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UpdateView()
        
        self.startLoader()
        fetchfromDB_store()
        self.initialiseValues()
        getItemsInfo_API()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.Setupnewview()
    }
}

//MARK: - TableView Delegates and Data Sources
extension StoreTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return menuArray.count + 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else {
            let expandableItem = itemsArray[section - 1]
            if expandableItem.isExpanded {
                let item = expandableItem.items
                return item.count + 1
            }
            else {
                return 1
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTitle_TV_Cell", for: indexPath) as! MenuTitle_TV_Cell
            guard let workingHr = storeInfo.workingHour  else { return cell }
            cell.workingHourLabel.text = workingHr
            return cell
        }
        else  {
            let menuObj = menuArray[(indexPath.section) - 1]
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MenuNameTitle_TV_Cell", for: indexPath) as! MenuNameTitle_TV_Cell
                cell.menuNameLabel.text = menuObj.menuName_eng
                cell.isCollapsedIndicatorVw.isHidden = true
                cell.seperatorView.isHidden = false
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetail_TV_Cell", for: indexPath) as! ItemDetail_TV_Cell
                let item = itemsArray[(indexPath.section) - 1].items
                let itemObj = item[indexPath.row - 1]
                cell.itemNameLabel.text = itemObj.itemName_eng
                cell.itemDescription.text = itemObj.itemDesc_eng
                cell.itemPriceLabel.text = itemObj.itemPrice! + " " + currencyString
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            if indexPath.row == 0 {
                self.handleCollapseExpand(indexPath: indexPath)
            }
        }
    }
}

//MARK: - Functionalities
extension StoreTableViewController {
    func UpdateView() {
        tableView.backgroundColor = UIColor.white
        Headerview = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 0
        tableView.addSubview(Headerview)
        
        NewHeaderLayer = CAShapeLayer()
        NewHeaderLayer.fillColor = UIColor.black.cgColor
        Headerview.layer.mask = NewHeaderLayer
        
        let newheight = Headerheight - Headercut / 2
        tableView.contentInset = UIEdgeInsets(top: newheight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -newheight)
        
        self.Setupnewview()
    }
    
    func Setupnewview() {
        let newheight = Headerheight - Headercut / 2
        var getheaderframe = CGRect(x: 0, y: -newheight, width: tableView.bounds.width, height: Headerheight)
        if tableView.contentOffset.y < newheight
        {
            getheaderframe.origin.y = tableView.contentOffset.y
            getheaderframe.size.height = -tableView.contentOffset.y + Headercut / 2
        }
        
        Headerview.frame = getheaderframe
        let cutdirection = UIBezierPath()
        cutdirection.move(to: CGPoint(x: 0, y: 0))
        cutdirection.addLine(to: CGPoint(x: getheaderframe.width, y: 0))
        cutdirection.addLine(to: CGPoint(x: getheaderframe.width, y: getheaderframe.height))
        cutdirection.addLine(to: CGPoint(x: 0, y: getheaderframe.height - Headercut))
        NewHeaderLayer.path = cutdirection.cgPath
    }
    
    func getItemsInfo_API() {
        let storeInfoURL = "https://www.jeebleybeta.com/services_new/services.php?action=menuCategories&rId=366&cuisineType=1&countryId=21&langId=1"
        
        guard let url = URL(string: storeInfoURL) else { return }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                print(data)
                let categoryInfo = try JSONDecoder().decode(CategoryArray.self, from: data)
                
                guard let _categoryInfo = categoryInfo.categoryArray else { return }
                
                self.saveToDB(categoryInfoObj: _categoryInfo)
                self.reloadTableView()
                self.endLoader()
                
            }
            catch let jsonErr {
                print("jsonErr :: \(jsonErr)")
            }
            }.resume()
        
    }
    
    func saveToDB(categoryInfoObj: [CategoryInfo]) {
        var i = 0
        for _category in categoryInfoObj {
            print("category \(i+1)")
            let newCategory : Category = CoreDataHelper.insertManagedObject("Category") as! Category
            newCategory.insertIntoDB(categoryData: _category)
            CoreDataHelper.saveManagedObjectContext()
            i += 1
        }
    }
    
    func startLoader () {
        self.view.isUserInteractionEnabled = false
        SVProgressHUD.setBackgroundColor(.white)
        SVProgressHUD.show()
    }
    
    func endLoader() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
        }
    }
    
    func reloadTableView() {
        fetchfromDB()
        intialiseItemsForMenu()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchfromDB_store() {
        let storeList = CoreDataHelper.fetchEntities("Store", withPredicate: [] ,sortkey: nil ,order:nil , limit : nil) as! [Store]
        storeInfo = storeList[0]
    }
    
    func fetchfromDB() {
        menuArray.removeAll()
        itemsArray.removeAll()
        let categoryList = CoreDataHelper.fetchEntities("Category", withPredicate: [] ,sortkey: nil ,order:nil , limit : nil) as! [Category]
//        menuArray = categoryList
        for menu in categoryList {
            menuArray.append(menu)
            if let items = menu.items?.allObjects as? [Item] {
//                itemsArray.append(items)
                let expandableItem = ExpandableItems(isExpanded: false, items: items)
                itemsArray.append(expandableItem)
            }
        }
    }
    
    func intialiseItemsForMenu() {
        itemsForMenu.removeAll()
        itemsCountForMenu.removeAll()
        for menu in menuArray {
            if let items = menu.items?.allObjects as? [Item] {
                let itemCount = items.count
                itemsCountForMenu.updateValue(itemCount, forKey: menu)
                itemsForMenu.updateValue(items, forKey: menu)
            }
        }
    }
    
    func handleCollapseExpand(indexPath:IndexPath) {
        var indexPaths = [IndexPath]()
        
//        for row in itemsArray[indexPath.section - 1].items.indices {
//            let indexP = IndexPath(row: row, section: indexPath.section)
//            indexPaths.append(indexP)
//        }
        let itemsCount = itemsArray[indexPath.section - 1].items.count + 1
        for row in 1 ..< itemsCount {
            let indexP = IndexPath(row: row, section: indexPath.section)
            indexPaths.append(indexP)
        }
        
        
        let isExpanded = itemsArray[indexPath.section - 1].isExpanded
        itemsArray[indexPath.section - 1].isExpanded = !isExpanded
        
        if !isExpanded {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 1, options: .curveEaseOut, animations: {
            view.isHidden = hidden
        })
    }
    
    func initialiseValues() {
        self.storeNameLabel.text = storeInfo.rName
        self.minOrdAmountLable.text = storeInfo.rMinOrderAmt! + " " + currencyString
        self.averageLabel.text = storeInfo.rDeliveryTime!
        self.deliveryFeeLabel.text = storeInfo.rDeliveryCharge! + " " +  currencyString
    }
}



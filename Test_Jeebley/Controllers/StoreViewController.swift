//
//  StoreViewController.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 27/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import UIKit
import SVProgressHUD

struct ExpandableItems {
    var isExpanded : Bool
    let items : [Item]
}

class StoreViewController: UIViewController,UIScrollViewDelegate {
    
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
extension StoreViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UpdateView()
        
        self.navigationVwTopConstraint.constant = -60
        
        
        self.startLoader()
        fetchfromDB_store()
        self.initialiseValues()
        getItemsInfo_API()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.storeTableView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.Setupnewview()
        print("tableVw content offset : \(storeTableView.contentOffset)")
        if storeTableView.contentOffset.y >= -5 {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationVwTopConstraint.constant = 0
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationVwTopConstraint.constant = -60
            })
        }
    }
}

//MARK: - Functionalities
extension StoreViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            if indexPath.row == 0 {
                self.handleCollapseExpand(indexPath: indexPath)
            }
        }
    }
    
    
}

//MARK: - Functionalities
extension StoreViewController {
    func UpdateView() {
        storeTableView.backgroundColor = UIColor.white
        Headerview = storeTableView.tableHeaderView
        storeTableView.tableHeaderView = nil
        storeTableView.rowHeight = UITableViewAutomaticDimension
        storeTableView.estimatedSectionHeaderHeight = 0
        storeTableView.addSubview(Headerview)
        
        NewHeaderLayer = CAShapeLayer()
        NewHeaderLayer.fillColor = UIColor.black.cgColor
        Headerview.layer.mask = NewHeaderLayer
        
        let newheight = Headerheight - Headercut / 2
        storeTableView.contentInset = UIEdgeInsets(top: newheight, left: 0, bottom: 0, right: 0)
        storeTableView.contentOffset = CGPoint(x: 0, y: -newheight)
        
        self.Setupnewview()
    }
    
    func Setupnewview() {
        let newheight = Headerheight - Headercut / 2
        var getheaderframe = CGRect(x: 0, y: -newheight, width: storeTableView.bounds.width, height: Headerheight)
        if storeTableView.contentOffset.y < newheight
        {
            getheaderframe.origin.y = storeTableView.contentOffset.y
            getheaderframe.size.height = -storeTableView.contentOffset.y + Headercut / 2
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
            self.storeTableView.reloadData()
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
            storeTableView.insertRows(at: indexPaths, with: .fade)
        }
        else {
            storeTableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 1, options: .curveEaseOut, animations: {
            view.isHidden = hidden
        })
    }
    
    func initialiseValues() {
        self.navigationTitleLabel.text = storeInfo.rName
        self.storeNameLabel.text = storeInfo.rName
        self.minOrdAmountLable.text = storeInfo.rMinOrderAmt! + " " + currencyString
        self.averageLabel.text = storeInfo.rDeliveryTime!
        self.deliveryFeeLabel.text = storeInfo.rDeliveryCharge! + " " +  currencyString
    }
}

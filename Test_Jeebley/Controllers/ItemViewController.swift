//
//  ItemViewController.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 29/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import UIKit
import SVProgressHUD

/// ItemViewController Handle the following
///   * List items
class ItemViewController: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var navigationTitleView: UIView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var navigationVwTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var itemTableView: UITableView!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var addCartButton: UIButton!
    
    //MARK: - IBActions
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    @IBAction func addCartButtonTapped(_ sender: Any) {
        self.dismissVC()
    }
    
    //MARK: - VC Variables
    var itemImage = UIImage()
    var item = Item()
    
    //hero ids to animation presentation of VC's
    var heroId_image = ""
    var heroId_label = ""
    var heroId_description = ""
    
}

//MARK: - Life cycles
extension ItemViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setHeroIds()
        self.UpdateView(tableView: self.itemTableView)
        initialiseVC()
        initialiseUI_VC()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.itemTableView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    /// Delegate to handle navigation view hide and show for table view scrolling
    ///
    /// - Parameter scrollView: scroll view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.Setupnewview(tableView: self.itemTableView)
        }
//        print("tableVw content offset : \(itemTableView.contentOffset)")
        if itemTableView.contentOffset.y >= -5 {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationVwTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationVwTopConstraint.constant = -70
                self.view.layoutIfNeeded()
            })
        }
    }
}

//MARK: - Table View Functionalities
extension ItemViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            // item description cell
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell_Ids.DESCRIPTION_CELL.rawValue, for: indexPath) as! Desciption_TV_Cell
            cell.descriptionLabel.text = item.itemDesc_eng
            cell.descriptionLabel.hero.id = self.heroId_description
            return cell
            
        case 1 :
            // choice title cell
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell_Ids.CHOICE_TITLE_CELL.rawValue, for: indexPath) as! ChoiceTitle_TV_Cell
            return cell
            
        case 2 :
            //add note cell
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell_Ids.ADD_NOTE_CELL.rawValue, for: indexPath) as! AddNote_TV_Cell
            return cell
            
        case 3 :
            //count custom cell
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell_Ids.COUNT_CUSTOM_CELL.rawValue, for: indexPath) as! CountCustom_TV_Cell
            
            //load customview
            if let _customCountView = Bundle.main.loadNibNamed(CustomView_Ids.COUNT_CUSTOM_VIEW.rawValue, owner: self, options: nil)?.first as? countCustomView {
                cell.countCustomView.addSubview(_customCountView)
            }
            return cell
            
        default :
            let cell = UITableViewCell()
            return cell
            
        }
    }
    
}

//MARK: - Functionalities
extension ItemViewController {
    
    
    /// dismissVC
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// initialise item VC
    func initialiseVC() {
        self.navigationTitleLabel.text = self.item.itemName_eng
        self.itemNameLabel.text = self.item.itemName_eng
        self.itemImageView.image = itemImage
    }
    
    
    /// initialise ItemVC UI
    func initialiseUI_VC() {
        self.navigationVwTopConstraint.constant = -70
        self.addCartButton.layer.cornerRadius = 3
        self.addCartButton.clipsToBounds = true
    }
    
    
    /// set hero ids to animation presentation
    func setHeroIds() {
        self.itemNameLabel.hero.id = self.heroId_label
        self.itemImageView.hero.id = self.heroId_image
    }
}


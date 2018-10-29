//
//  DataModels.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 26/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import Foundation
import UIKit

public struct RestaurentInfo: Decodable {
    let response_code: Int?
    let restaurantAreaInfo: StoreInfo?
}

public struct StoreInfo: Decodable {
    let rId:String?
    let rName:String?
    let rImage:String?
    let rDeliveryCharge:String?
    let rMinOrderAmt:String?
    let rDeliveryTime:String?
    let branchStatus:String?
    let cntrCurrency:String?
    let openingStatus:String?
    let workingHour:String?
}

public struct CategoryArray: Decodable {
    let categoryArray: [CategoryInfo]?
}

public struct CategoryInfo: Decodable{
    let mastMId:String?
    let menuCatId:String?
    let menuName_eng:String?
    let menuArray:[ItemInfo]?
}

public struct ItemInfo: Decodable{
    let itemId:String?
    let itemName_eng:String?
    let itemImage:String?
    let itemDesc_eng:String?
    let itemFoodType:String?
    let itemMinQty:String?
    let itemPrice:String?
    let logoImage:String?
    let status:String?
}




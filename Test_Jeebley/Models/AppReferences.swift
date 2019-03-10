//
//  AppReferences.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 30/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import Foundation
import UIKit


/// Application Details for global access
///
/// - NAME: Application Name
public enum AppDetails : String {
    case NAME = "Test_Jeebley"
}


/// ViewController Class names for global access
///
/// - BASE_VC: BaseViewController
/// - SPLASH_VC: SplashViewController
/// - STORE_VC: StoreViewController
/// - ITEM_VC: ItemViewController
public enum ViewControllers : String{
    case BASE_VC = "BaseViewController"
    case SPLASH_VC = "SplashViewController"
    case STORE_VC = "StoreViewController"
    case ITEM_VC = "ItemViewController"
}

/// Entity Names for global access
///
/// - STORE: Store Entity
/// - CATEGORY: Category Entity
/// - ITEM: Item Entity
public enum Entities : String{
    case STORE = "Store"
    case CATEGORY = "Category"
    case ITEM = "Item"
}


/// Segue Identifiers for global access
///
/// - SPLASH_STORE: Segue name from Splash VC to Store VC
/// - STORE_ITEM: Segue name from Store VC to Item VC
public enum SegueIds : String {
    case SPLASH_STORE = "showStoreVC"
    case STORE_ITEM = "showItemVC"
}


/// Service status of API Response for global access
///
/// - SUCCESS: success
/// - FAILED: failed
/// - SERVICE_ERROR: service error
/// - ERROR: error
public enum ServiceStatus : String {
    case SUCCESS = "success"
    case FAILED = "failed"
    case SERVICE_ERROR = "Service Error"
    case ERROR = "Error"
}


/// Request method of API Call for global access
///
/// - GET: GET
/// - POST: POST
public enum RequestMethod : String {
    case GET = "GET"
    case POST = "POST"
}


/// Table View Cell Identifiers for global access
///
/// - MENU_TITLE_CELL: MenuTitle_TV_Cell
/// - MENU_TITLE_NAME_CELL: MenuNameTitle_TV_Cell
/// - ITEM_DETAIL_CELL: ItemDetail_TV_Cell
/// - DESCRIPTION_CELL: Desciption_TV_Cell
/// - CHOICE_TITLE_CELL: ChoiceTitle_TV_Cell
/// - ADD_NOTE_CELL: AddNote_TV_Cell
/// - COUNT_CUSTOM_CELL: CountCustom_TV_Cell
public enum TableViewCell_Ids : String {
    case MENU_TITLE_CELL = "MenuTitle_TV_Cell"
    case MENU_TITLE_NAME_CELL = "MenuNameTitle_TV_Cell"
    case ITEM_DETAIL_CELL = "ItemDetail_TV_Cell"
    case DESCRIPTION_CELL = "Desciption_TV_Cell"
    case CHOICE_TITLE_CELL = "ChoiceTitle_TV_Cell"
    case ADD_NOTE_CELL = "AddNote_TV_Cell"
    case COUNT_CUSTOM_CELL = "CountCustom_TV_Cell"
}


/// Table View Cell Identifiers for global access
///
/// - COUNT_CUSTOM_VIEW: countCustomView
public enum CustomView_Ids : String {
    case COUNT_CUSTOM_VIEW = "countCustomView"
}

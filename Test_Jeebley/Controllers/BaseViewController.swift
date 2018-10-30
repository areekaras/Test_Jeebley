//
//  BaseViewController.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 30/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import UIKit
import SystemConfiguration

/// BaseViewController Handle the following
///   * Carries Common Functionalities of views
///   * status bar style and background
class BaseViewController: UIViewController,UIScrollViewDelegate {

    //MARK: - VC Variables
    // header view
    var Headerview : UIView!
    var NewHeaderLayer : CAShapeLayer!
    private let Headerheight : CGFloat = 225
    private let Headercut : CGFloat = 0
    
    var currencyString = "KD"

}

//MARK: - Life Cycles
extension BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addstatusBar(colour: .clear)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

//MARK: - HeaderView Functionalities
extension BaseViewController {
    /// Update header view
    ///
    /// - Parameter tableView: tableview contained header view
    func UpdateView(tableView: UITableView) {
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
        
        self.Setupnewview(tableView: tableView)
    }
    
    
    /// customise up header view
    ///
    /// - Parameter tableView: table view contained header view
    func Setupnewview(tableView: UITableView) {
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
}

//MARK: - Common Functionalities
extension BaseViewController {
    
    /// Chande status bar back ground color
    ///
    /// - Parameter colour: background color needed to be
    func addstatusBar (colour : UIColor)
    {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = colour
    }
    
    
    /// show aler view
    ///
    /// - Parameters:
    ///   - title: title message
    ///   - message: message to share on alert
    func showAlert(title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    /// checking internet availability
    ///
    /// - Returns: return availablity of internet Boolean
    func isInternetAvailable() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    
    
    /// Animation for view hide and show
    ///
    /// - Parameters:
    ///   - view: view needs to be animated
    ///   - hidden: hide/show boolean value
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 1, options: .curveEaseOut, animations: {
            view.isHidden = hidden
        })
    }

    
}

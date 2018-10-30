//
//  countCustomView.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 29/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import UIKit


/// Add or increment item count
class countCustomView: UIView {

    //set a default count
    var count = "1"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var minusView: UIView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var plusView: UIView!
    @IBOutlet weak var minusLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    override func awakeFromNib() {
        self.countLabel.text = count
    }
    
    
    /// minus button tapped
    ///  count will decrement upto 1
    /// - Parameter sender: button
    @IBAction func minusButtonTapped(_ sender: Any) {
        if Int(count)! > 1 {
            let _count = Int(count)! - 1
            count = "\(_count)"
            self.countLabel.text = count
        }
    }
    
    /// plus button tapped
    ///  count will increment
    /// - Parameter sender: button
    @IBAction func plusButtonTapped(_ sender: Any) {
        let _count = Int(count)! + 1
        count = "\(_count)"
        self.countLabel.text = count
    }
    
}

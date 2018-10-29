//
//  MenuNameTitle_TV_Cell.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 28/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import UIKit

class MenuNameTitle_TV_Cell: UITableViewCell {

    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var isCollapsedIndicatorVw: UIView!
    @IBOutlet weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

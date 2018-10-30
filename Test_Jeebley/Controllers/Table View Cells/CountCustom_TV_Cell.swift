//
//  CountCustom_TV_Cell.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 29/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import UIKit

class CountCustom_TV_Cell: UITableViewCell {
   
    @IBOutlet weak var countCustomView_border: UIView!
    @IBOutlet weak var countCustomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countCustomView_border.layer.borderWidth = 1
        countCustomView_border.layer.borderColor = UIColor.lightGray.cgColor
        countCustomView_border.layer.cornerRadius = 3
        countCustomView_border.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

//
//  FilterTableViewCell.swift
//  Desafio Mobile
//
//  Created by Arthur on 18/06/2023.
//  Copyright © 2023 Arthur. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameFilter: UILabel!
    @IBOutlet weak var swFilter: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         swFilter.isOn = false
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

//
//  ResourceTableViewCell.swift
//  Desafio Mobile
//
//  Created by Arthur on 17/06/2023.
//  Copyright © 2023 Arthur. All rights reserved.
//

import UIKit

class ResourceTableViewCell: UITableViewCell {

    @IBOutlet weak var resource_id: UILabel!
    @IBOutlet weak var update_at: UILabel!
    @IBOutlet weak var resource_value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

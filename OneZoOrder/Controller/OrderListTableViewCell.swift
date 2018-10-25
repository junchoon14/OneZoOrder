//
//  OrderListTableViewCell.swift
//  OneZoOrder
//
//  Created by Jason Hsu on 2018/8/26.
//  Copyright © 2018 junchoon. All rights reserved.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teaNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    @IBOutlet weak var cupLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

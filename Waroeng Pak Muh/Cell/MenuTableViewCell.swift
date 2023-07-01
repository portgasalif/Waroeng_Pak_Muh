//
//  MenuTableViewCell.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 08/04/23.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.tag = 0
        minusButton.tag = 1
    }
    
}

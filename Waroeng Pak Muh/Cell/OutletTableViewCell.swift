//
//  OutletTableViewCell.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 01/05/23.
//

import UIKit

class OutletTableViewCell: UITableViewCell {

    @IBOutlet weak var kotaLabel: UILabel!
    @IBOutlet weak var alamatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

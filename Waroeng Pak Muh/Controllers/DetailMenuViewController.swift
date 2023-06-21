//
//  detailMenuViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 10/04/23.
//

import UIKit
class DetailMenuViewController: UIViewController {
    
    @IBOutlet weak var detailImageMenu: UIImageView!
    @IBOutlet weak var detailMenuLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    var selectedMenu: Menu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let menu = selectedMenu {
            detailMenuLabel.text = menu.menuItems
            detailImageMenu.image = UIImage(named: menu.imageMenu)
            descLabel.text = menu.description
        }
    }
}


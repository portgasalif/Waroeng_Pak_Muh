//
//  DetailPenawarn2ViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 14/05/23.
//

import UIKit
class DetailPromo2ViewController: UIViewController {
    
    @IBOutlet weak var detailPromoImage: UIImageView!
    var selectedPromo : Promo?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let promo = selectedPromo {
            detailPromoImage.image = UIImage(named: promo.imagePromo)
        }
    }
}

//
//  DetailPenawarn2ViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 14/05/23.
//

import UIKit

class DetailPenawarn2ViewController: UIViewController {

    @IBOutlet weak var detailPromoImage: UIImageView!
    @IBOutlet weak var detailButtonPromo: UIButton!
    var selectedPromo : Promo?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let promo = selectedPromo {
            detailPromoImage.image = UIImage(named: promo.imagePromo)
        }
    }
    @IBAction func detailButtonPromoPressed(_ sender: UIButton) {
        MetodeBayarClass.selectedPromoPrice = 1
//        
    }
    override func viewDidDisappear(_ animated: Bool) {
        MetodeBayarClass.selectedPromoPrice = 0
    }
}

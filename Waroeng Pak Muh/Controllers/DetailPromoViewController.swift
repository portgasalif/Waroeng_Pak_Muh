//
//  DetailPenawaranViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 17/04/23.
//

import UIKit
class DetailPromoViewController: UIViewController {
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
        
        let alert = UIAlertController(title: "Promo berhasil digunakan", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // action setelah user menekan tombol OK
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func detailButtonPromoCancelPressed(_ sender: UIButton) {
        MetodeBayarClass.selectedPromoPrice = 0
        let alert = UIAlertController(title: "Promo berhasil dibatalkan", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // action setelah user menekan tombol OK
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

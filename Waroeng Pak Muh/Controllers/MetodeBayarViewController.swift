//
//  MetodeBayarViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 16/04/23.
//

import UIKit


class MetodeBayarViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func metodePembayaranDana(_ sender: UIButton) {
        MetodeBayarClass.selectedMethod = 1
        let alertcontroller = UIAlertController(title: "Dana Telah Dipilih", message: "", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "OK", style: .default)
        alertcontroller.addAction(okaction)
        present(alertcontroller, animated: true, completion: nil)
        }
    
    @IBAction func metodePembayaranShoopePay(_ sender: UIButton) {
        MetodeBayarClass.selectedMethod = 2
        let alertcontroller = UIAlertController(title: "Shopee Pay Telah Dipilih", message: "", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "OK", style: .default)
        alertcontroller.addAction(okaction)
        present(alertcontroller, animated: true, completion: nil)
    }
    @IBAction func metodePembayaranOVO(_ sender: UIButton) {
        MetodeBayarClass.selectedMethod = 3
        let alertcontroller = UIAlertController(title: "OVO Telah Dipilih", message: "", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "OK", style: .default)
        alertcontroller.addAction(okaction)
        present(alertcontroller, animated: true, completion: nil)
    }
    @IBAction func metodePembayaranCash(_ sender: UIButton) {
        MetodeBayarClass.selectedMethod = 4
        let alertcontroller = UIAlertController(title: "Cash Telah Dipilih", message: "", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "OK", style: .default)
        
        alertcontroller.addAction(okaction)
        present(alertcontroller, animated: true, completion: nil)
    }
    
    
    
}







//
//  BatalkanPesananViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 28/06/23.
//

import UIKit

class BatalkanPesananViewController: UIViewController {
    
    
    @IBOutlet weak var myTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func konfirmasiBatal(_ sender: UIButton) {
        MetodeBayarClass.selectedMethod = 0
        MetodeBayarClass.selectedPromoPrice = 0
    }
}

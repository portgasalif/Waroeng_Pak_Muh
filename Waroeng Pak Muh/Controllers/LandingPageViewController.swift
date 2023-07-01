//
//  LandingPageController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 03/02/23.
//

import UIKit
class LandingPageViewController: UIViewController {
    
    @IBOutlet weak var myView1: UIView!
    @IBOutlet weak var myView2: UIView!
    @IBOutlet weak var myView3: UIView!
    @IBOutlet weak var myView4: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Menambahkan shadow pada keempat view
        for myView in [myView1, myView2, myView3, myView4] {
            // Membuat sudut bulat pada keempat view
            myView?.layer.cornerRadius = 10
            myView?.layer.masksToBounds = true
            
            // Menambahkan garis tepi pada keempat view
            let borderLayer = CAShapeLayer()
            borderLayer.path = UIBezierPath(roundedRect: myView?.bounds ?? .zero, cornerRadius: myView?.layer.cornerRadius ?? 0).cgPath
            borderLayer.lineWidth = 0.3
            borderLayer.strokeColor = UIColor.black.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor
            myView?.layer.addSublayer(borderLayer)
        }
    }
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        // Anda dapat menambahkan kode di sini untuk melakukan tugas yang relevan selama proses penutupan
    }

}

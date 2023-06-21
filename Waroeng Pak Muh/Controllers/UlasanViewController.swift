//
//  UlasanViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 10/05/23.
//

import UIKit

class UlasanViewController: UIViewController {
    
    @IBOutlet weak var myTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTextView.layer.borderWidth = 1
        myTextView.layer.borderColor = UIColor.gray.cgColor
        myTextView.layer.cornerRadius = 10
    }
    @IBAction func kirimUlasanButtonPressed(_ sender: UIButton) {
        guard let ulasanText = myTextView.text, !ulasanText.isEmpty else {
            // jika teks kosong, tampilkan alert
            let kosongAlert = UIAlertController(title: "Error", message: "Teks ulasan tidak boleh kosong", preferredStyle: .alert)
            kosongAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(kosongAlert, animated: true, completion: nil)
            return
        }
        
        // buat alert
        let suksesAlert = UIAlertController(title: "Sukses", message: "Ulasan telah tersimpan, terima kasih atas ulasannya", preferredStyle: .alert)
        // tambahkan action OK
        suksesAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // setelah mengklik OK, reset isi text view menjadi kosong
            self.myTextView.text = ""
        }))
        // tampilkan alert
        present(suksesAlert, animated: true, completion: nil)
    }
}

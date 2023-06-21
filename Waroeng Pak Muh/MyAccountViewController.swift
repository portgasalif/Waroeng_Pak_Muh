//
//  MyAccountViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 12/02/23.
//

import UIKit
import Firebase
import FirebaseAuth

class MyAccountViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func deleteAccountPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Hapus Akun", message: "Apakah Anda yakin ingin menghapus akun?", preferredStyle: .alert)
        let hapusAction = UIAlertAction(title: "Hapus", style: .destructive) { (action) in
            Auth.auth().currentUser?.delete(completion: { (error) in
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Success", message: "Akun Berhasil Dihapus", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        
        let batalAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        alert.addAction(hapusAction)
        alert.addAction(batalAction)
        self.present(alert, animated: true, completion: nil)
               
    }

    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

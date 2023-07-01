//
//  ViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 30/01/23.
//

import UIKit
import Firebase
class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        MetodeBayarClass.selectedMethod = 0
        MetodeBayarClass.selectedPromoPrice = 0
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                emailTextField.text = ""
                passwordTextField.text = ""
    }
    //MARK: - Keyboard Section
    @objc func keyboardWillShow(_ notification: Notification) {
        // Ambil ukuran keyboard
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        // Geser frame view Anda ke atas sesuai dengan ukuran keyboard
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -keyboardSize.height
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        // Geser frame view Anda kembali ke posisi semula
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        let enteredEmail = emailTextField.text
        let enteredPassword = passwordTextField.text
        
        Auth.auth().signIn(withEmail: enteredEmail!, password: enteredPassword!) { (result, error) in
            if let error = error {
                // Show alert for incorrect email or password
                let alert = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            guard let currentUser = Auth.auth().currentUser else {
                print("Tidak ada pengguna yang masuk")
                return
            }
            
            let userID = currentUser.uid
            let db = Firestore.firestore()
            
            // Cek apakah koleksi alamat sudah ada untuk pengguna saat ini
            db.collection("users").document(userID).collection("addresses").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Terjadi kesalahan saat mengambil koleksi alamat: \(error)")
                    return
                }
                
                if snapshot?.isEmpty == true {
                    // Jika koleksi alamat belum ada, buat koleksi baru untuk pengguna saat ini
                    db.collection("users").document(userID).collection("addresses").addDocument(data: [:]) { error in
                        if let error = error {
                            print("Terjadi kesalahan saat membuat koleksi alamat: \(error)")
                        } else {
                            print("Koleksi alamat berhasil dibuat")
                            self.performSegue(withIdentifier: "LoginToIn", sender: self)
                        }
                    }
                } else {
                    // Jika koleksi alamat sudah ada, langsung pindah ke halaman berikutnya
                    self.performSegue(withIdentifier: "LoginToIn", sender: self)
                }
            }
        }
    }
}

//
//  ForgotPWDViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 06/02/23.
//

import UIKit
import Firebase

class ForgotPWDViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        // Tambahkan observer keyboardWillShow dan keyboardWillHide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        emailTextField.delegate = self
    }
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
            emailTextField.resignFirstResponder()
        }
        return true
    }
    @IBAction func forgotPWDPressed(_ sender: UIButton) {
        let email = emailTextField.text
        
        Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
            if let error = error {
                
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                // Show an alert message if the reset email was sent successfully
                let alert = UIAlertController(title: "Success", message: "Password reset email sent. Please check your inbox.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    // Dismiss current view controller after user taps "OK"
                    self.navigationController?.popToRootViewController(animated: true)
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                self.emailTextField.text = ""
            }
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
    }
}

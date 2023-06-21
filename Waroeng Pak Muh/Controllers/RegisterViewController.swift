//
//  RegisterView.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 31/01/23.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        let email = emailTextField.text
        let password = pwdTextField.text
        Auth.auth().createUser(withEmail: email!, password: password!) { (result, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "RegisterToIn", sender: self)
                let alert = UIAlertController(title: "Success", message: "Registration successful", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        // Tambahkan observer keyboardWillShow dan keyboardWillHide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        emailTextField.delegate = self
        pwdTextField.delegate = self
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
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            pwdTextField.becomeFirstResponder()
        } else if textField == pwdTextField {
            pwdTextField.resignFirstResponder()
        }
        return true
    }
}


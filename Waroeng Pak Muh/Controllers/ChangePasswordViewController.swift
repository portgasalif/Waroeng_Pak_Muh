//
//  myAccountViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 10/02/23.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func changePassword(newPassword: String) {
        let user = Auth.auth().currentUser
        user?.updatePassword(to: newPassword) { (error) in
            if let error = error {
                // Show error alert to user
                let errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                errorAlert.addAction(okAction)
                self.present(errorAlert, animated: true, completion: nil)
            } else {
                // Show success alert to user
                
                let successAlert = UIAlertController(title: "Success", message: "Password changed successfully!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                successAlert.addAction(okAction)
        
                self.present(successAlert, animated: true, completion: nil)
                self.newPasswordTextField.text = " "
            }
        }
    }
    @IBAction func changePasswordPressed(_ sender: UIButton) {
        // get new password from textfield
        guard let newPassword = newPasswordTextField.text else {
            return }
        changePassword(newPassword: newPassword)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

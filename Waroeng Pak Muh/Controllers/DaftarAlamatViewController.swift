//
//  InputAlamatViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 25/04/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct Alamat: Codable {
    let nama: String
    var nohp: String
    let detailalamat: String
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "nama": nama,
            "nohp": nohp,
            "detailalamat": detailalamat
        ]
        //Firestore memerlukan data dalam bentuk kamus untuk menambahkan dokumen baru ke database. Oleh karena itu, dictionaryRepresentation digunakan untuk mengonversi data dari Alamat struct ke dalam bentuk kamus yang dapat diterima oleh Firestore.
    }
}
class DaftarAlamatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var namaTextField: UITextField!
    @IBOutlet weak var noHpTextField: UITextField!
    @IBOutlet weak var alamatTextField: UITextField!
    @IBOutlet weak var AlamattableView: UITableView!
    var data: [Alamat] = []
    var userID: String?
    var db: Firestore!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup NSFetchedResultsController
        AlamattableView.dataSource = self
        AlamattableView.delegate = self
        checkDataInFirestore()
        if let currentUser = Auth.auth().currentUser {
            userID = currentUser.uid
        }
        
        db = Firestore.firestore()
        fetchAddresses()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Tambahkan observer keyboardWillShow dan keyboardWillHide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        // Set delegasi UITextField
        namaTextField.delegate = self
        noHpTextField.delegate = self
        alamatTextField.delegate = self
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
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AlamattableView.dequeueReusableCell(withIdentifier: "AlamatTableViewCell", for: indexPath) as! AlamatTableViewCell
        // Ambil data dari array
        let alamat = data[indexPath.row]
        
        // Set label pada cell
        cell.nameLabel.text = alamat.nama
        cell.noHpLabel.text = alamat.nohp
        cell.alamatLabel.text = alamat.detailalamat
        
        return cell
    }
    
    // Enable editing of the table view
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Tampilkan alert untuk meminta konfirmasi dari pengguna
            let alert = UIAlertController(title: "Hapus Alamat", message: "Apakah Anda yakin ingin menghapus alamat ini?", preferredStyle: .alert)
            let hapusAction = UIAlertAction(title: "Hapus", style: .destructive) { _ in
                // Ambil data alamat yang akan dihapus
                let alamat = self.data[indexPath.row]
                
                // Hapus data dari Firestore
                guard let userID = self.userID else {
                    print("Tidak ada pengguna yang masuk")
                    return
                }
                
                self.db.collection("users").document(userID).collection("addresses").whereField("nama", isEqualTo: alamat.nama).getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Terjadi kesalahan saat menghapus alamat: \(error)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("Dokumen tidak ditemukan")
                        return
                    }
                    
                    for document in documents {
                        document.reference.delete()
                    }
                    
                    // Hapus data dari array data
                    self.data.remove(at: indexPath.row)
                    
                    // Reload tabel
                    self.AlamattableView.reloadData()
                }
            }
            let batalAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
            alert.addAction(hapusAction)
            alert.addAction(batalAction)
            present(alert, animated: true, completion: nil)
        }
    }
    // MARK: - Actions
    @IBAction func simpanButtonTapped(_ sender: Any) {
        guard let userID = userID else {
            print("Tidak ada pengguna yang masuk")
            return
        }
        
        guard let nama = namaTextField.text, !nama.isEmpty,
              let noHp = noHpTextField.text, !noHp.isEmpty,
              let detailAlamat = alamatTextField.text, !detailAlamat.isEmpty else {
            // Menampilkan alert jika ada UITextField yang kosong
            let alert = UIAlertController(title: "Error", message: "Harap isi semua field", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let alamatBaru = Alamat(nama: nama, nohp: noHp, detailalamat: detailAlamat)
        
        db.collection("users").document(userID).collection("addresses").addDocument(data: alamatBaru.dictionaryRepresentation) { error in
            if let error = error {
                print("Terjadi kesalahan saat menambahkan alamat: \(error)")
            } else {
                print("Alamat berhasil ditambahkan")
                self.clearFields()
                self.fetchAddresses()
                
                // Menampilkan alert ketika alamat berhasil ditambahkan
                let successAlert = UIAlertController(title: "Sukses", message: "Alamat berhasil ditambahkan", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                successAlert.addAction(okAction)
                self.present(successAlert, animated: true, completion: nil)
            }
        }
    }
}
extension DaftarAlamatViewController {
    func checkDataInFirestore() {
        guard let userID = userID else {
            print("Tidak ada pengguna yang masuk")
            return
        }
        db.collection("users").document(userID).collection("addresses").getDocuments { (snapshot, error) in
            if let error = error {
                print("Terjadi kesalahan saat mengambil data: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Data tidak ditemukan")
                return
            }
            
            if documents.isEmpty {
                print("Data tidak tersedia")
            } else {
                print("Data tersedia")
            }
        }
    }
    
    func listenToDataChanges() {
        guard let userID = userID else {
            print("Tidak ada pengguna yang masuk")
            return
        }
        
        db.collection("users").document(userID).collection("addresses").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Terjadi kesalahan saat mendengarkan perubahan data: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Data tidak ditemukan")
                return
            }
            
            if documents.isEmpty {
                print("Data tidak tersedia")
            } else {
                print("Data tersedia")
            }
        }
    }
        func fetchAddresses() {
            guard let userID = userID else {
                print("Tidak ada pengguna yang masuk")
                return
            }
            
            db.collection("users").document(userID).collection("addresses").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Terjadi kesalahan saat mengambil alamat: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("Dokumen tidak ditemukan")
                    return
                }
                
                self.data = documents.compactMap { document -> Alamat? in
                    let data = document.data()
                    let nama = data["nama"] as? String ?? ""
                    let nohp = data["nohp"] as? String ?? ""
                    let detailalamat = data["detailalamat"] as? String ?? ""
                    return Alamat(nama: nama, nohp: nohp, detailalamat: detailalamat)
                }
                // Mengurutkan data alamat berdasarkan nama
                self.data.sort { $0.nama < $1.nama }
                self.AlamattableView.reloadData()
            }
        }
        
        func clearFields() {
            namaTextField.text = ""
            noHpTextField.text = ""
            alamatTextField.text = ""
        }
    }


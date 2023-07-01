//
//  PilihLokasiViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 29/04/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

protocol PilihLokasiDelegate: AnyObject {
    func didSelect(detailAlamat: String, nama: String )
}

class PilihLokasiViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: PilihLokasiDelegate?
    
    var data: [Alamat] = []
    var userID: String?
    var db: Firestore!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Inisialisasi Firestore
        db = Firestore.firestore()
        
        // Cek apakah ada pengguna yang masuk
        if let currentUser = Auth.auth().currentUser {
            userID = currentUser.uid
        }
        // Ambil data alamat dari Firestore
        fetchAddresses()
        
        // Set dataSource dan delegate untuk table view
        tableView.dataSource = self
        tableView.delegate = self
        
        // Reload table view
        tableView.reloadData()
    }
    
    //MARK: - Table Code
    // Implementasi delegate dan dataSource untuk table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PilihLokasiTableViewCell", for: indexPath) as! PilihLokasiTableViewCell
        
        // Ambil data dari array
        let alamat = data[indexPath.row]
        
        // Set label pada cell
        cell.nameLabel.text = alamat.nama
        cell.noHpLabel.text = alamat.nohp
        cell.alamatLabel.text = alamat.detailalamat
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAlamat = data[indexPath.row]
        delegate?.didSelect(detailAlamat: selectedAlamat.detailalamat, nama: selectedAlamat.nama)
        dismiss(animated: true, completion: nil)
    }
    
}
extension PilihLokasiViewController {
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
            
            // Reload table view
            self.tableView.reloadData()
        }
    }
}

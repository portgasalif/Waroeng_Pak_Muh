//
//  BayarViewViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 11/03/23.
//

import UIKit
class BayarViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var checkoutTableView: UITableView!
    @IBOutlet weak var totalFixLabel: UILabel!
    @IBOutlet weak var biayaAntarLabel: UILabel!
    @IBOutlet weak var detailAlamat: UITextField!
    @IBOutlet weak var bayarButton: UIButton!
    @IBOutlet weak var alamatLabel: UILabel!
    @IBOutlet weak var namaLabel: UILabel!
    @IBOutlet weak var promoView: UIView!
    @IBOutlet weak var hargaPromoLabel: UILabel!
    @IBOutlet weak var lokasiRestoButton: UIButton!
    @IBOutlet weak var metodeBayarButton: UIButton!
    var selectedDetailAlamat: String?
    
    var dataPesanan: [Menu] = []
    var totalPrice: Double = 0.0
    let biayaAntar : Double = 10.0
    var promoPrice : Double = 12.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alamatLabel.text = selectedDetailAlamat
        totalLabel.text = String(format: "Rp%.3f", totalPrice)
        biayaAntarLabel.text = String(format: "Rp%.3f", biayaAntar)
        
        checkoutTableView.delegate = self
        checkoutTableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let attributedText = NSAttributedString(string: "Rp12.000", attributes: [.strikethroughStyle: NSUnderlineStyle.thick.rawValue])
        hargaPromoLabel.attributedText = attributedText
        
        updatePromo()
        updateTotalHarga()
        updateMetodeBayar()
        detailAlamatHidden()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        updatePromo()
        updateTotalHarga()
        updateMetodeBayar()
        detailAlamatHidden()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Jumlah row = jumlah data di array Menu
        return dataPesanan.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkoutTableViewCell", for: indexPath) as! checkoutTableViewCell
        
        let menu = dataPesanan[indexPath.row]
        cell.checkoutLabel.text = menu.menuItems
        cell.checkoutMenuPrices.text = String(format: "Rp%.3f", menu.prices * Double(menu.qtys))
        cell.checkoutImage.image = UIImage(named: menu.imageMenu)
        
        return cell
    }
    //MARK: - Bayar Button Tapped
    @IBAction func bayarButtonTapped(_ sender: UIButton) {
        if namaLabel.text?.isEmpty ?? true {
            // namaLabel kosong, tampilkan peringatan
            let alertController = UIAlertController(title: "Error", message: "Alamat harus diisi", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else if lokasiRestoButton.titleLabel?.text == "Pilih Lokasi Resto" {
            // lokasiRestoButton belum dipilih, tampilkan peringatan
            let alertController = UIAlertController(title: "Error", message: "Lokasi resto harus dipilih", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else if MetodeBayarClass.selectedMethod == 0 {
            // Metode pembayaran belum dipilih
            let alertController = UIAlertController(title: "Error", message: "Metode pembayaran harus dipilih", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            // namaLabel tidak kosong dan lokasiRestoButton sudah dipilih dan MetodeBayarClass.selectedMethod tidak sama dengan 0, lanjutkan dengan pembayaran
            let alertController = UIAlertController(title: "Pembayaran Berhasil", message: "Terima kasih telah melakukan pembayaran", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.performSegue(withIdentifier: "BayarToDetailPesanan", sender: self)
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pilihLokasiVC = segue.destination as? PilihLokasiViewController {
            // set the delegate to self
            pilihLokasiVC.delegate = self
        } else if let locationOutletMenuViewController = segue.destination as? LocationOutletMenuViewController {
            locationOutletMenuViewController.delegate = self
        } else if let alamat = sender as? Alamat {
            selectedDetailAlamat = alamat.detailalamat
        }
        else if segue.identifier == "BayarToDetailPesanan" {
            let detailHistoryVC = segue.destination as! DetailPesananViewController
            detailHistoryVC.totalPrice = self.totalPrice
            detailHistoryVC.dataPesanan = self.dataPesanan
            detailHistoryVC.selectedAlamat = self.alamatLabel.text
            detailHistoryVC.selectedNama = self.namaLabel.text
                   
        }
    }
}

extension BayarViewController: PilihLokasiDelegate {
    func didSelect(detailAlamat: String, nama: String) {
        selectedDetailAlamat = detailAlamat
        alamatLabel.text = detailAlamat
        namaLabel.text = nama
        detailAlamatHidden()
        
    }
}

extension BayarViewController: LocationOutletMenuViewControllerDelegate {
    func didSelectAddress(_ address: WPMAddress) {
        lokasiRestoButton.setTitle("Waroeng Pak Muh \(address.city)", for: .normal)
    }
}
extension BayarViewController {
    func updatePromo() {
        if MetodeBayarClass.selectedPromoPrice == 1 {
            promoView.isHidden = false
        } else {
            promoView.isHidden = true
        }
    }
    
    func updateTotalHarga() {
        if MetodeBayarClass.selectedPromoPrice == 1 {
            totalFixLabel.text = String(format: "Total: Rp%.3f", totalPrice + biayaAntar - promoPrice)
        } else {
            totalFixLabel.text = String(format: "Total: Rp%.3f", totalPrice + biayaAntar)
        }
    }
    
    func updateMetodeBayar() {
        switch MetodeBayarClass.selectedMethod {
        case 1:
            metodeBayarButton.setTitle("Dana", for: .normal)
            
        case 2:
            metodeBayarButton.setTitle("Shopee Pay", for: .normal)
            
        case 3:
            metodeBayarButton.setTitle("OVO", for: .normal)
            
        case 4:
            metodeBayarButton.setTitle("Cash", for: .normal)
            
        default:
            metodeBayarButton.setTitle("Metode Pembayaran", for: .normal)
        }
    }
    func detailAlamatHidden(){
        if namaLabel.text == nil || namaLabel.text == "" {
            detailAlamat.isHidden = true
        }
        else {
            detailAlamat.isHidden = false
        }
    }
}

//
//  LocationOutletMenuViewController.swift
//  
//
//  Created by Alif Fachrel A on 30/05/23.
//

import UIKit

protocol LocationOutletMenuViewControllerDelegate: AnyObject {
    func didSelectAddress(_ address: WPMAddress)
}

class LocationOutletMenuViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var outletTableView2: UITableView!
    let addresses = [
        WPMAddress(street: "Jl. buah batu no.220 cijagra, kecamatan Lengkong. Kota Bandung - Jawa Barat.", city: "Bandung"),
        WPMAddress(street: "Jl. Moh Toha No 58", city: "Kota Cirebon"),
        WPMAddress(street: "Ruko Sentra Niaga, J. Boulevard Hijau Raya Blok B8 No. 06", city: "Kel. Pejuang, Kec. Medan Satria, Bekasi"),
        WPMAddress(street: "JL. Margonda Raya No. 243b RT 01/ RW 12", city: "Kel. Kemiri Muka, Kecamatan Beji, Depok"),
        WPMAddress(street: "Jalan Raya Jatiwaringin No 45 RT 11 RW 06 Jatiwaringin", city: "Kel Jaticempaka Kecamatan Pondok Gede"),
        WPMAddress(street: "Ruko Apartemen Greenlake Sunter Blok TB - EA. JI. Danau Sunter Utara", city: "Kel. Sunter Agung, Kecamatan Tanjung Priok, Jakarta Utara"),
        WPMAddress(street: "Grand poris A10/23A RT/RW 12/09", city: "Cipondok Indah, Tangerang"),
        WPMAddress(street: "Ruko Azores Blok B17A No. 23", city: "Perum. Banjar Wijaya, Poris Plawad, Kecamatan Cipondoh, Kota Tangerang"),
        WPMAddress(street: "Jl. Krekot Bunder raya no. 73", city: "Sawah Besar, Jakarta Pusat"),
        WPMAddress(street: "Ruko Arjuna No. 18C JI. Arjuna", city: "Kelurahan Kauman, Kota Malang, Jawa Timur"),
        WPMAddress(street: "JlI. Dr. Ir. H. Soekarno M21, kel, Rungkut Kidul", city: "Kecamatan Rungkut, Kota SBY, Jawa Timur"),
        WPMAddress(street: "jl. Tunjungan no.82", city: "Kota Surabaya"),
        WPMAddress(street: "Jl. Merdeka No. 16", city: "Kota Samarinda, Kalimantan Timur")
    ]
    var lokasiResto = LokasiRestoClass()
    weak var delegate: LocationOutletMenuViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outletTableView2.delegate = self
        outletTableView2.dataSource = self
    }
    //MARK: - Table Code
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationOutletMenuTableViewCell", for: indexPath) as! LocationOutletMenuTableViewCell
        
        let address = addresses[indexPath.row]
        cell.kotaLabel.text = address.city
        cell.alamatLabel.text = address.street
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = addresses[indexPath.row]
              delegate?.didSelectAddress(address)
        dismiss(animated: true, completion: nil)
    }
    
    
}

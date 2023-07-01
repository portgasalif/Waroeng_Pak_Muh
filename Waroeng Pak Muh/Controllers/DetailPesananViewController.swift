//
//  DetailHistoryViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 16/04/23.
//

import UIKit
import MapKit
class DetailPesananViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var historyMenuTable: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalFixLabel: UILabel!
    @IBOutlet weak var biayaAntarLabel: UILabel!
    @IBOutlet weak var promoLabel: UILabel!
    @IBOutlet weak var hargaPromoLabelDetail: UILabel!
    @IBOutlet weak var alamatPenerima: UILabel!
    @IBOutlet weak var namaPenerima: UILabel!
    
    var dataPesanan: [Menu] = []
    var totalPrice: Double = 0.0
    let biayaAntar : Double = 10.0
    var promoPrice : Double = 12.0
    var selectedDetailAlamat: String?
    var selectedNama: String?
    var selectedAlamat: String?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestureRecognizer()
        updatePromoLabel()
        updateHargaPromoLabel()
        updateTotalHarga()
        locationManagerDelegate()
        detailPenerima()
        
        historyMenuTable.delegate = self
        historyMenuTable.dataSource = self
        
        biayaAntarLabel.text = "Rp10.000"
        let attributedText = NSAttributedString(string: "Rp12.000", attributes: [.strikethroughStyle: NSUnderlineStyle.thick.rawValue])
        hargaPromoLabelDetail.attributedText = attributedText
        
        // Hide the back button
        self.navigationItem.hidesBackButton = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyDetailTableViewCell", for: indexPath) as! historyDetailTableViewCell
        
        let menu = dataPesanan[indexPath.row]
        cell.historyLabel.text = menu.menuItems
        cell.historyPrices.text = String(format: "Rp. %.3f", menu.prices * Double(menu.qtys))
        cell.historyImage.image = UIImage(named: menu.imageMenu)
        
        return cell
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    //MARK: - Button
    @IBAction func kembaliKeBeranda(_ sender: UIButton) {
        MetodeBayarClass.selectedMethod = 0
        MetodeBayarClass.selectedPromoPrice = 0
    }
    
}
//MARK: - Function-Function
extension DetailPesananViewController{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func updateTotalHarga() {
        totalLabel.text = String(format: "Rp%.3f", totalPrice)
        
        if MetodeBayarClass.selectedPromoPrice == 1 {
            totalFixLabel.text = String(format: "Total: Rp%.3f", totalPrice + biayaAntar - promoPrice)
        } else {
            totalFixLabel.text = String(format: "Total: Rp%.3f", totalPrice + biayaAntar)
        }
    }
    func updateHargaPromoLabel() {
        if MetodeBayarClass.selectedPromoPrice == 1 {
            hargaPromoLabelDetail.isHidden = false
        } else {
            hargaPromoLabelDetail.isHidden = true
        }
    }
    func updatePromoLabel(){
        if MetodeBayarClass.selectedPromoPrice == 1 {
            promoLabel.isHidden = false
        } else {
            promoLabel.isHidden = true
        }
    }
    func locationManagerDelegate(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func detailPenerima(){
        namaPenerima.text = selectedNama
        alamatPenerima.text = selectedAlamat
    }
}

//
//  DetailHistoryViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 16/04/23.
//

import UIKit
import MapKit
class DetailHistoryViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var historyMenuTable: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalFixLabel: UILabel!
    @IBOutlet weak var biayaAntarLabel: UILabel!
    @IBOutlet weak var hargaPromoLabel: UILabel!
    @IBOutlet weak var promoLabel: UILabel!
    var dataPesanan: [Menu] = []
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestureRecognizer()
        setupLabels()
        loadData()
        updatePromoLabel()
        updateHargaPromoLabel()
        
        historyMenuTable.delegate = self
        historyMenuTable.dataSource = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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
        cell.historyPrices.text = String(format: "Rp.%.3f", menu.prices * Double(menu.qtys))
        cell.historyImage.image = UIImage(named: menu.imageMenu)
        
        return cell
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension DetailHistoryViewController{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setupLabels() {
        let text = "Rp.12.000"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                      value: 2,
                                      range: NSRange(location: 0, length: text.count))
        hargaPromoLabel.attributedText = attributedString
    }
    
    func loadData() {
        if let savedData = UserDefaults.standard.object(forKey: "dataPesanan") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode([Menu].self, from: savedData) {
                dataPesanan = loadedData
            }
        }
        
        // Muat data dari UserDefaults
        let total = UserDefaults.standard.double(forKey: "total")
        let totalFix = UserDefaults.standard.double(forKey: "totalFix")
        let hargaPromo = UserDefaults.standard.double(forKey: "hargaPromo")
        
        // Tampilkan data di label
        totalLabel.text = String(format: "Rp.%.3f", total)
        totalFixLabel.text = String(format: "Total: Rp.%.3f", totalFix)
        hargaPromoLabel.text = String(format: "Rp.%.3f", hargaPromo)
    }
    
    func updateHargaPromoLabel() {
        if MetodeBayarClass.selectedPromoPrice == 1 {
            hargaPromoLabel.isHidden = false
        } else {
            hargaPromoLabel.isHidden = true
        }
    }
    func updatePromoLabel(){
        if MetodeBayarClass.selectedPromoPrice == 1 {
            promoLabel.isHidden = false
        } else {
            promoLabel.isHidden = true
        }
    }
    
}

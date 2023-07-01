//
//  RiwayatDetailViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 28/06/23.
//

import UIKit
import MapKit
class RiwayatDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var historyMenuTable: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalFixLabel: UILabel!
    @IBOutlet weak var biayaAntarLabel: UILabel!
    @IBOutlet weak var promoLabel: UILabel!
    @IBOutlet weak var hargaPromoLabelDetail: UILabel!
    
    var data: [Menu] = [
        Menu(menuItems: "Bakso Keju", description: "1 Bakso Keju Besar 3 Bakso Polos Mie Kuning dan Bihun", prices: 29, qtys: 0, imageMenu: "Bakso_Keju"),
        Menu(menuItems: "Bakso Mercon", description: "1 Bakso Mercon Besar 3 Bakso Polos Mie Kuning dan Bihun", prices: 29, qtys: 0, imageMenu: "Bakso_Mercon"),
        Menu(menuItems: "Nasi", description: "1 Porsi Nasi", prices: 6, qtys: 0, imageMenu: "Nasi"),
        Menu(menuItems: "Air Mineral", description: "", prices: 6, qtys: 0,imageMenu: "Air_Mineral"),
        Menu(menuItems: "Teh Pucuk", description: "", prices: 5, qtys: 0,imageMenu: "Teh_Pucuk")]
    var totalPrice: Double = 0.0
    let biayaAntar : Double = 10.0
    var promoPrice : Double = 12.0
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestureRecognizer()
        locationManagerDelegate()
        
        
        historyMenuTable.delegate = self
        historyMenuTable.dataSource = self
        
        biayaAntarLabel.text = "Rp10.000"
        let attributedText = NSAttributedString(string: "Rp12.000", attributes: [.strikethroughStyle: NSUnderlineStyle.thick.rawValue])
        hargaPromoLabelDetail.attributedText = attributedText
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Jumlah row = jumlah data di array Menu
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyDetailTableViewCell", for: indexPath) as! historyDetailTableViewCell
        
        let menu = data[indexPath.row]
        cell.historyLabel.text = menu.menuItems
        cell.historyPrices.text = String(format: "Rp. %.3f", menu.prices)
        cell.historyImage.image = UIImage(named: menu.imageMenu)
        
        return cell
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
   
//MARK: - Function-Function
extension RiwayatDetailViewController{
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
   
    func locationManagerDelegate(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

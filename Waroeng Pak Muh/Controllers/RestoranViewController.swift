//
//  restoranViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 11/02/23.
//

import UIKit
import MapKit
import CoreLocation

class RestoranViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let pakMuhCoordinate = CLLocationCoordinate2D(latitude: -6.941433418508923, longitude: 107.62681265633694)
        
        let pakMuhAnnotation = MKPointAnnotation()
        pakMuhAnnotation.coordinate = pakMuhCoordinate
        pakMuhAnnotation.title = "Waroeng Pak Muh"
        pakMuhAnnotation.subtitle = "Cabang Bandung"
        
        mapView.addAnnotation(pakMuhAnnotation)
        
    }
    
    @IBAction func updateLocation(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

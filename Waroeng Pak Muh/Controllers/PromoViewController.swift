//
//  PenawaranViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 17/04/23.
//

import UIKit
struct Promo {
    let imagePromo: String
}
class PromoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataPromo: [Promo] = [
        Promo(imagePromo: "Promo1"),
        Promo(imagePromo: "Promo2"),
        Promo(imagePromo: "Promo3"),
        Promo(imagePromo: "Promo4"),
        Promo(imagePromo: "Promo5"),
        Promo(imagePromo: "Promo6"),
        Promo(imagePromo: "Promo7"),
        Promo(imagePromo: "Promo8")]
    
    @IBOutlet weak var promoTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        promoTable.dataSource = self
    }
    
    //MARK: - Table Code
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPromo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "penawaranTableCell", for: indexPath) as! PenawaranTableViewCell
        
        let promo = dataPromo[indexPath.row]
        
        cell.penawaranImage.image = UIImage(named: promo.imagePromo)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPromo = dataPromo[indexPath.row]
        performSegue(withIdentifier: "detailPromoSegue", sender: selectedPromo)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailPromoViewController,
           let indexPath = promoTable.indexPathForSelectedRow {
            detailVC.selectedPromo = dataPromo[indexPath.row]
        }
    }
}

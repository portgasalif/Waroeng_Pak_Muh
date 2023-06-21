////
////  PesanViewController.swift
////  Waroeng Pak Muh
////
////  Created by Alif Fachrel A on 17/02/23.
////
import UIKit

class PesanViewController: UIViewController, UISearchBarDelegate  {
    
    
    
    @IBOutlet var steppers: [UIStepper]!
    @IBOutlet var qtyLabels: [UILabel]!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var bayarButton: UIButton!
    @IBOutlet weak var bayarView: UIView!
    @IBOutlet var menuImageViews: [UIImageView]!
    @IBOutlet var menuLabels: [UILabel]!
   
    @IBOutlet var searchBar: UISearchBar!
    let menuItems = ["Bakso Keju", "Bakso Mercon", "Bakso Telur", "Bakso Urat", "Bakso Halus", "Nasi","Mie Kuning","Bihun", "Pangsit", "Kerupuk", "Air Mineral", "Teh Pucuk"]
    var prices: [Double] = [29, 29, 29, 29, 23, 6, 3, 3, 5, 3, 6 , 5]
    var qtys: [Int] = [0, 0, 0,0, 0, 0,0, 0, 0,0, 0, 0]
    var searchResults: [String] = []

  
    var vc: BayarViewController?
    var total: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBar
        
        for (index, menuItem) in menuItems.enumerated() {
            // Memuat gambar dari folder "Menu" di Assets.xcassets
            let imageName = menuItem.replacingOccurrences(of: " ", with: "_")
            let image = UIImage(named: imageName)
            
            menuImageViews[index].image = image
            
            // Menyesuaikan teks pada label menu
            menuLabels[index].text = "\(menuItem)"
        }
        
        // Mengatur nilai UIStepper dan qtyLabels
        for (index, stepper) in steppers.enumerated() {
            stepper.value = Double(qtys[index])
            qtyLabels[index].text = "\(qtys[index])"
        }
        
        updateTotal()
        searchBar.delegate = self
    }
    
    func filter() {
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchResults = menuItems.filter { $0.lowercased().contains(searchText.lowercased()) }
        } else {
            searchResults = menuItems
        }
        // update tampilan
        for (index, menuItem) in searchResults.enumerated() {
            let imageName = menuItem.replacingOccurrences(of: " ", with: "_")
            let image = UIImage(named: imageName)
            menuImageViews[index].image = image
            menuLabels[index].text = "\(menuItem)"
        }
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = menuItems.filter({ $0.lowercased().contains(searchText.lowercased()) })
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
        filter()
       }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let index = steppers.firstIndex(of: sender)!
        qtys[index] = Int(sender.value)
        qtyLabels[index].text = "\(qtys[index])"
        updateTotal()
    }
    func updateTotal() {
        total = 0
        for (index, qty) in qtys.enumerated() {
            total += prices[index] * Double(qty)
            
        }
        if qtys.allSatisfy({ $0 == 0 }) {
            totalLabel.text = ""
            bayarView.isHidden = true
            
        } else {
            totalLabel.text = String(format: "Total: Rp %.3f", Double(total))
            bayarView.isHidden = false
        }
    }
    
    @IBAction func bayarButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "bayarSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bayarSegue" {
            if let vc = segue.destination as? BayarViewController {
                vc.totalBayar = total
            }
        }
    }
}





//
//  PesanTableViewController.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 08/04/23.
//

import UIKit

class PesanTViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var bayarButton: UIButton!

    
    var filteredData: [Menu] = []
    var isSearching = false
    //MARK: - Array
    
    var data: [Menu] = [
        Menu(menuItems: "Bakso Keju", description: "1 Bakso Keju Besar 3 Bakso Polos Mie Kuning dan Bihun", prices: 29, qtys: 0, imageMenu: "Bakso_Keju"),
        Menu(menuItems: "Bakso Mercon", description: "1 Bakso Mercon Besar 3 Bakso Polos Mie Kuning dan Bihun", prices: 29, qtys: 0, imageMenu: "Bakso_Mercon"),
        Menu(menuItems: "Bakso Telur",description: "1 Bakso Telur Besar 3 Bakso Polos Mie Kuning dan Bihun", prices: 29, qtys: 0,imageMenu: "Bakso_Telur"),
        Menu(menuItems: "Bakso Urat",description: "1 Bakso Urat Besar 3 Bakso Polos Mie Kuning dan Bihun", prices: 29, qtys: 0,imageMenu: "Bakso_Urat"),
        Menu(menuItems: "Bakso Halus", description: "5 Bakso Polos Mie Kuning dan Bihun", prices: 23, qtys: 0,imageMenu: "Bakso_Halus"),
        Menu(menuItems: "Nasi", description: "1 Porsi Nasi", prices: 6, qtys: 0, imageMenu: "Nasi"),
        Menu(menuItems: "Mie Kuning",description: "1 Porsi Mie Kuning", prices: 3, qtys: 0, imageMenu: "Mie_Kuning"),
        Menu(menuItems: "Bihun", description: "1 Porsi Bihun", prices: 3, qtys: 0, imageMenu: "Bihun"),
        Menu(menuItems: "Pangsit", description: "1 Porsi Pangsit Isi 3", prices: 5, qtys: 0,imageMenu: "Pangsit"),
        Menu(menuItems: "Kerupuk", description: "", prices: 3, qtys: 0,imageMenu: "Kerupuk"),
        Menu(menuItems: "Air Mineral", description: "", prices: 6, qtys: 0,imageMenu: "Air_Mineral"),
        Menu(menuItems: "Teh Pucuk", description: "", prices: 5, qtys: 0,imageMenu: "Teh_Pucuk")]
    
    var totalPrice: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTable.dataSource = self
        updateTotalPrice()
    }
    //MARK: - Searchbar Code
    func filterData(for searchText: String) {
        filteredData = data.filter { $0.menuItems.lowercased().contains(searchText.lowercased()) }
        menuTable.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredData.removeAll()
        } else {
            isSearching = true
            filteredData = data.filter { $0.menuItems.lowercased().contains(searchText.lowercased()) }
        }
        menuTable.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    //MARK: - Table Code
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredData.count : data.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menu = isSearching ? filteredData[indexPath.row] : data[indexPath.row]
        let cell = menuTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        cell.menuLabel.text = menu.menuItems
        cell.menuImageView.image = UIImage(named: menu.imageMenu)
        
        cell.qtyLabel.text = "\(menu.qtys)"
        cell.priceLabel.text = String(format: "Rp%.3f", menu.prices)
        // Set target-action untuk button "+"
        cell.addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        // Set tag agar kita dapat mengidentifikasi indexPath dari cell yang di-tap
        cell.addButton.tag = indexPath.row
        
        // Set target-action untuk button "-"
        cell.minusButton.addTarget(self, action: #selector(minusButtonTapped(_:)), for: .touchUpInside)
        // Set tag agar kita dapat mengidentifikasi indexPath dari cell yang di-tap
        cell.minusButton.tag = indexPath.row
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedMenu: Menu
        if isSearching {
            selectedMenu = filteredData[indexPath.row]
        } else {
            selectedMenu = data[indexPath.row]
        }
        performSegue(withIdentifier: "DetailSegue", sender: selectedMenu)
    }
    //MARK: - Button ketika di click
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        if isSearching {
            filteredData[index].qtys += 1
            if let dataIndex = data.firstIndex(where: { $0.menuItems == filteredData[index].menuItems }) {
                data[dataIndex].qtys = filteredData[index].qtys
            }
        } else {
            data[index].qtys += 1
        }
        menuTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        updateTotalPrice()
    }
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        if isSearching {
            if filteredData[index].qtys > 0 {
                filteredData[index].qtys -= 1
                if let dataIndex = data.firstIndex(where: { $0.menuItems == filteredData[index].menuItems }) {
                    data[dataIndex].qtys = filteredData[index].qtys
                }
            }
        } else {
            if data[index].qtys > 0 {
                data[index].qtys -= 1
            }
        }
        menuTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        updateTotalPrice()
    }
    //MARK: - Function Total Harga
    func updateTotalPrice() {
        var totalPrice: Double = 0.0
        for menu in data {
            totalPrice += menu.prices * Double(menu.qtys)
        }
        self.totalPrice = totalPrice
        // update label totalLabel pada view controller
        bayarButton.setTitle(String(format: "Rp%.3f", totalPrice), for: .normal)
        bayarButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        // update visibility of bayarButton
        bayarButton.isHidden = totalPrice == 0.0
    }
    //MARK: - Passing Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BayarSegue" {
            let bayarVC = segue.destination as! BayarViewController
            bayarVC.totalPrice = self.totalPrice
            bayarVC.dataPesanan = self.data.filter({ $0.qtys > 0 })
        } else if segue.identifier == "DetailSegue" {
            if let indexPath = self.menuTable.indexPathForSelectedRow {
                let detailVC = segue.destination as! DetailMenuViewController
                if isSearching {
                    detailVC.selectedMenu = filteredData[indexPath.row]
                } else {
                    detailVC.selectedMenu = data[indexPath.row]
                }
              
            }
        }
    }
}

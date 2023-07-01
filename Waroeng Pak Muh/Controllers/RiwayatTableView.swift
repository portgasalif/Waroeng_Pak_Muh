//
//  historyTableView.swift
//  Waroeng Pak Muh
//
//  Created by Alif Fachrel A on 10/04/23.
//

import UIKit
class RiwayatTableView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var historyTable: UITableView!
    let words = ["17 April 2023", "15 April 2023"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view controller as the data source and delegate of the table view
        historyTable.dataSource = self
        historyTable.delegate = self
    }
    // MARK: - Table view data source
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Return the number of rows in the section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    // Configure the cell for the corresponding row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableViewCell", for: indexPath)
        cell.textLabel?.text = words[indexPath.row]
        return cell
    }
}

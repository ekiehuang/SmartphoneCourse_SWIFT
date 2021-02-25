//
//  TableViewController.swift
//  Assignment4_tableView_cities
//
//  Created by Huang Ekie on 2/11/21.
//

import UIKit

class TableViewController: UITableViewController {

    let cities = ["Seattle", "LA", "Las Vegas", "Hong Kong", "Paris"]
    let temperature = ["32F", "45F", "58F", "72F", "28F"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.lblCity.text = cities[indexPath.row]
        cell.lblTem.text = temperature[indexPath.row]

        return cell
    }
}

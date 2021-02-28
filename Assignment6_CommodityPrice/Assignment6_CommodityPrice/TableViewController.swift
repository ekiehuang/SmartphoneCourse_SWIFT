//
//  TableViewController.swift
//  Assignment6_CommodityPrice
//
//  Created by Huang Ekie on 2/27/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import PromiseKit

class TableViewController: UITableViewController {
    
    @IBOutlet var tblCmd: UITableView!
    
    var commodityArr : [Commodity] = [Commodity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commodityArr.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        cell.lblName.text = commodityArr[indexPath.row].name
        cell.lblPrice.text = String(commodityArr[indexPath.row].price)

        return cell
    }
    
    func getUrl() -> String{
        var url = apiURL
        url.append(apiKey)
        return url
    }
    
    func getData(){
        let url = getUrl()
        getQuickShortQuote(url)
            .done { (commodities) in
                self.commodityArr = [Commodity]()
                for commodity in commodities{
                    self.commodityArr.append(commodity)
                }
                self.tblCmd.reloadData()
            }.catch { (error) in
                print(error)
            }
        
    }
    
    func getQuickShortQuote(_ url : String) -> Promise<[Commodity]>{
        return Promise<[Commodity]>{
            seal -> Void in
            
            //SwiftSpinner.show("Getting Commodity Price...")
            AF.request(url).responseJSON { (response) in
                //SwiftSpinner.hide()
                if response.error == nil{
                    var arr = [Commodity]()
                    guard let data = response.data else {
                        return
                    }
                    guard let commodities = JSON(data).array else{
                        return
                    }
                    self.commodityArr = [Commodity]()
                    for commodity in commodities{
                        let name = commodity["name"].stringValue
                        let price = commodity["price"].floatValue
                        
                        let commodity = Commodity(name: name, price: price)
                        arr.append(commodity)
                    }
                    seal.fulfill(arr)
                }else{
                    seal.reject(response.error!)
                }
            }//end of AF
        }//end of promise
    }// end of func
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


}

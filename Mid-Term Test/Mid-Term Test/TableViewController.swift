//
//  TableViewController.swift
//  Mid-Term Test
//
//  Created by Huang Ekie on 3/30/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import PromiseKit

class TableViewController: UITableViewController {
    
    @IBOutlet var tblCovid: UITableView!
    
    var covidArr : [Covid] = [Covid]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return covidArr.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.lblState.text = covidArr[indexPath.row].state
        cell.lblTotal.text = String(covidArr[indexPath.row].total)
        cell.lblPositive.text = String(covidArr[indexPath.row].positive)
        

        return cell
    }
    
    func getData(){
        let url = "https://api.covidtracking.com/v1/states/current.json"
        getCovidData(url)
            .done { (results) in
                self.covidArr = [Covid]()
                for result in results{
                    self.covidArr.append(result)
                }
                self.tblCovid.reloadData()
            }.catch { (error) in
                print(error)
            }
        
    }
    
    func getCovidData(_ url : String) -> Promise<[Covid]>{
        return Promise<[Covid]>{
            seal -> Void in
            
            //SwiftSpinner.show("Getting Covid Data...")
            AF.request(url).responseJSON { (response) in
                //SwiftSpinner.hide()
                if response.error == nil{
                    var arr = [Covid]()
                    guard let data = response.data else {
                        return
                    }
                    guard let allCovid = JSON(data).array else{
                        return
                    }
                    self.covidArr = [Covid]()
                    for item in allCovid{
                        let state = item["state"].stringValue
                        let total = item["total"].intValue
                        let positive = item["positive"].intValue
                        
                        let item = Covid(state: state, total: total, positive: positive)
                        arr.append(item)
                    }
                    seal.fulfill(arr)
                }else{
                    seal.reject(response.error!)
                }
            }//end of AF
        }//end of promise
    }// end of func


}

//
//  TableViewController.swift
//  Assignment5_News
//
//  Created by Huang Ekie on 2/21/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class TableViewController: UITableViewController {
    
    var titleArr : [String] = [String]()
    var articleArr : [Article] = [Article]()

    @IBOutlet var tblNews: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.lblTitle.text = titleArr[indexPath.row]
        
        return cell
    }
    
    func getUrl() -> String{
        return apiURL + apiKey
    }
    
    func getData(){
    
        let url = getUrl()
    
        AF.request(url).responseJSON { (response) in
            if response.error == nil {
                guard let data = response.data else {return}
                if let json = try? JSON(data: data) {
                    for item in json["articles"].arrayValue{
                        let title = item["title"].stringValue
                        let author = item["author"].stringValue
                        let description = item["description"].stringValue
                        self.articleArr.append(Article(author: author, title: title, description: description))
                        self.titleArr.append(title)
                    }
                }
        self.tblNews.reloadData()
       }
     }
   }
}



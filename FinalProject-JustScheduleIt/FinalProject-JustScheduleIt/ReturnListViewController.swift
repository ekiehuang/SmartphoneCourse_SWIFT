//
//  ReturnListViewController.swift
//  FinalProject-JustScheduleIt
//
//  Created by Huang Ekie on 4/28/21.
//

import UIKit
import Firebase

class ReturnListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//    @IBOutlet weak var onelbl: UILabel!
//
//    @IBOutlet weak var twolbl: UILabel!
//
//    @IBOutlet weak var threelbl: UILabel!
    
    @IBOutlet weak var returnTableView: UITableView!
    
    var resListArr : [ListCategoryModel] = [ListCategoryModel]()
    var db : Firestore!
    
    var condition = String()
    var duration = String()
    var location = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        onelbl.text = condition
//        twolbl.text = duration
//        threelbl.text = location
        
        self.returnTableView.delegate = self
        self.returnTableView.dataSource = self
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        returnList()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = Bundle.main.loadNibNamed("ReturnListCell", owner: self, options: nil)?.first as! ReturnListCell
        cell.content.text = resListArr[indexPath.row].content
        cell.priority.text = String(resListArr[indexPath.row].priority)
        cell.duration.text = String(resListArr[indexPath.row].duration)
        cell.location.text = resListArr[indexPath.row].location
        cell.condition.text = String(resListArr[indexPath.row].condition)

        return cell
    }

    
   
    
    func returnList(){
        let conditionNum = Int(condition)
        let durationNum = Double(duration)
        let categoryRef = db.collection("ListCategory")
        
        self.resListArr = [ListCategoryModel]()
        categoryRef
            //.order(by: "condition")
            //.order(by: "duration")
            .order(by: "priority")
            .whereField("location", isEqualTo: location)
            .whereField("condition", isEqualTo: conditionNum)
            .whereField("duration", isEqualTo: durationNum)
            .limit(to: 2)
            .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let documentId = document.get("categoryID") as! String
                            let content = document.get("content") as! String
                            let loc = document.get("location") as! String
                            let cond = document.get("condition") as! Int
                            let dura = document.get("duration") as! Double
                            let pri = document.get("priority") as! Int
                            
                            let toToList = ListCategoryModel(categoryID: documentId, content: content, priority: pri, location: loc, duration: dura, condition: cond)
                            self.resListArr.append(toToList)
                            
                        }
                        self.returnTableView.reloadData()
                    }
            }
    }
    
    
    

}

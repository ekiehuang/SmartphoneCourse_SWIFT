//
//  ListViewController.swift
//  FinalProject-JustScheduleIt
//
//  Created by Huang Ekie on 3/23/21.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var listTableView: UITableView!

    var listArr : [ListCategoryModel] = [ListCategoryModel]()

    var db : Firestore!
    
    //let delegateList = AddListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        getData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = Bundle.main.loadNibNamed("ListTableViewCell", owner: self, options: nil)?.first as! ListTableViewCell
        cell.lblContent.text = listArr[indexPath.row].content
        cell.lblPri.text = String(listArr[indexPath.row].priority)
        cell.lblDur.text = String(listArr[indexPath.row].duration)
        cell.lblLoc.text = listArr[indexPath.row].location
        cell.lblCon.text = String(listArr[indexPath.row].condition)

        return cell
    }
    
    //MARK: Delete a task
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //get id of the selected row
        let id = self.listArr[indexPath.row].categoryID
        //delete in the tableview
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Finished") { (action, indexPath) in
            self.listArr.remove(at: indexPath.row)
            self.listTableView.deleteRows(at: [indexPath], with: .fade)
            
            //delete the document in Firestore
            self.db.collection("ListCategory").whereField("categoryID", isEqualTo: id).getDocuments { (querySnapshot, error) in
                    if error != nil {
                        print(error)
                    } else {
                        for document in querySnapshot!.documents {
                            document.reference.delete()
                        }
                    }
                }
        }
        return [deleteAction]
    }
    
    //MARK: Get Data from Firebase
    func getData(){
        db.collection("ListCategory").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.listArr = [ListCategoryModel]()
                for document in querySnapshot!.documents {
                    
//                    print("\(document.documentID) => \(document.data())")
//                    print(document.get("content")!)
                    
                    let documentId = document.get("categoryID") as! String
                    let content = document.get("content") as! String
                    let location = document.get("location") as! String
                    let condition = document.get("condition") as! Int
                    let duration = document.get("duration") as! Double
                    let priority = document.get("priority") as! Int
                    
                    let toToList = ListCategoryModel(categoryID: documentId, content: content, priority: priority, location: location, duration: duration, condition: condition)
                    self.listArr.append(toToList)
                    
                }
                self.listTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
}

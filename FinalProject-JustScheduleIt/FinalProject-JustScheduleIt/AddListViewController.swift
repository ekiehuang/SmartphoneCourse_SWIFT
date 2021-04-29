//
//  AddListViewController.swift
//  FinalProject-JustScheduleIt
//
//  Created by Huang Ekie on 3/23/21.
//

import UIKit
import Firebase
import FirebaseFirestore


class CellClass: UITableViewCell{
    
}

class AddListViewController: UIViewController{
    
    @IBOutlet weak var lblContent: UITextField!
    
    @IBOutlet weak var priorityBtn: UIButton!

    @IBOutlet weak var lblDur: UITextField!
    
    @IBOutlet weak var locationBtn: UIButton!
    
    @IBOutlet weak var conditionBtn: UIButton!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet var wholeView: UIView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    
    var dataSource = [String]()
    
    var db : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    
    func addTransparentView(frames : CGRect){
        //let window = UIApplication.shared.keyWindow
        //transparentView.frame = window?.frame ?? self.view.frame
        //self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        //transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut,animations: {
            //self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView(){
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut,animations: {
            self.transparentView.alpha = 0
            //self.tableView.frame = CGRect(x: frames.maxX, y: frames.maxY + frames.height, width: frames.width, height: frames.height)
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    
    @IBAction func clickOnPriority(_ sender: Any) {
        dataSource = [
                    "1",
                    "2",
                    "3"
                    ]
        selectedButton = priorityBtn
        addTransparentView(frames: priorityBtn.frame)
    }
    
    @IBAction func clickOnLocation(_ sender: Any) {
        dataSource = [
                    "Home",
                    "Outside",
                    "Travel"
                    ]
        selectedButton = locationBtn
        addTransparentView(frames: locationBtn.frame)
    }
    
    @IBAction func clickOnCondition(_ sender: Any) {
        dataSource = [
                    "1",
                    "2",
                    "3"
                    ]
        selectedButton = conditionBtn
        addTransparentView(frames: conditionBtn.frame)
        
    }
    
    
    @IBAction func cancelFunc(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func confirmFunc(_ sender: Any) {
        guard let content = lblContent.text else{return}
        
        guard let priorityStr = priorityBtn.titleLabel?.text else{return}
        if priorityStr == "Select Priority"{
            lblStatus.text = "Please Complete the Information"
            return
        }
        let priority = Int(priorityStr)
        
        guard let location = locationBtn.titleLabel?.text else{return}
        
        guard let conditionStr = conditionBtn.titleLabel?.text else{return}
        if conditionStr == "Select Condition" {
            lblStatus.text = "Please Complete the Information"
            return
        }
        let condition = Int(conditionStr)
        
        guard let durationStr = lblDur.text else{return}
        if durationStr == ""{
            lblStatus.text = "Please Complete the Information"
            return
        }
        let duration = Double(durationStr)
        
        if content == "" || location == "Select Location"{
            lblStatus.text = "Please Complete the Information"
            return
        }
        
        let newCategory = self.db.collection("ListCategory").document()
        
        let category = ListCategoryModel(categoryID: newCategory.documentID, content: content, priority: priority!, location: location, duration: duration!, condition: condition!)
        
        newCategory.setData([
            "categoryID" : category.categoryID,
            "content" : category.content,
            "priority" : category.priority,
            "location" : category.location,
            "duration" : category.duration,
            "condition" : category.condition
                ])
        
        let alertTitle = NSMutableAttributedString(string: "New List")
        let alertMsg = NSMutableAttributedString(string: "New List Added Successfully!")
        
        self.displayAlert(title: alertTitle, msg: alertMsg)
       
    }
    
    //MARK: setup alert controller
        func displayAlert(title: NSMutableAttributedString, msg: NSMutableAttributedString) {
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            //alert.setValue(title, forKey: "attributedTitle")
            alert.setValue(msg, forKey: "attributedMessage")

            let action = UIAlertAction(title: "OK", style: .default){ alertAction in
                //self.delegate?.didUpdate(self)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                
            }

            alert.addAction(action)

            present(alert, animated: true, completion: nil)
            
    }
}

extension AddListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
    
    
}

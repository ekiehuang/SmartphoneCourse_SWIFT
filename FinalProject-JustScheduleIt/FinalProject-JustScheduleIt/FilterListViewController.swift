//
//  FilterListViewController.swift
//  FinalProject-JustScheduleIt
//
//  Created by Huang Ekie on 4/28/21.
//

import UIKit
import Firebase

class FilterListCellClass: UITableViewCell{
    
}

class FilterListViewController: UIViewController {

    @IBOutlet weak var conditionBtn: UIButton!
    
    @IBOutlet weak var durationLbl: UITextField!
    
    @IBOutlet weak var locationBtn: UIButton!
    
    
    let transparentView = UIView()
    let dropTableView = UITableView()
    let recomTableView = UITableView()
    
    var selectedButton = UIButton()
    
    var dataSource = [String]()
    //var resListArr : [ListCategoryModel] = [ListCategoryModel]()
        
    var db : Firestore!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dropTableView.delegate = self
        dropTableView.dataSource = self
        dropTableView.register(FilterListCellClass.self, forCellReuseIdentifier: "Cell")
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    func addTransparentView(frames : CGRect){
        
        dropTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(dropTableView)
        dropTableView.layer.cornerRadius = 5
        dropTableView.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut,animations: {
            self.dropTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView(){
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut,animations: {
            self.transparentView.alpha = 0
      
            self.dropTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue"{
            let destinationController = segue.destination as! ReturnListViewController
            destinationController.condition = conditionBtn.titleLabel!.text!
            destinationController.duration = durationLbl.text!
            destinationController.location = locationBtn.titleLabel!.text!
        }
    }
    
    @IBAction func selectCondi(_ sender: Any) {
        dataSource = [
                    "1",
                    "2",
                    "3"
                    ]
        selectedButton = conditionBtn
        addTransparentView(frames: conditionBtn.frame)
    }
    
    @IBAction func selectLoc(_ sender: Any) {
        dataSource = [
                    "Home",
                    "Outside",
                    "Travel"
                    ]
        selectedButton = locationBtn
        addTransparentView(frames: locationBtn.frame)
    }
}

extension FilterListViewController: UITableViewDelegate, UITableViewDataSource {
    
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


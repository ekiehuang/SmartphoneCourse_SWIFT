//
//  ViewController.swift
//  FinalProject-JustScheduleIt
//
//  Created by Huang Ekie on 3/22/21.
//

import UIKit
import Firebase
import SwiftSpinner


class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtpassword: UITextField!
    
    
    
    @IBOutlet weak var lblStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.text = ""
        // Do any additional setup after loading the view.
    }
    
    func addKeychainAfterLogin(_ uid : String){
        let keychain = KeychainService().keychain
        keychain.set(uid, forKey: "uid")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let keychain = KeychainService().keychain
        
        if keychain.get("uid") != nil{
            //user has already logged in
            //perform segue
            performSegue(withIdentifier: "dashboardSegue", sender: self)
        }
    }
    
    

    @IBAction func loginFunc(_ sender: Any) {
        guard let email = txtEmail.text else{
            return
        }
        guard let password = txtpassword.text else{
            return
        }
        
        if email.isValidEmail == false {
            lblStatus.text = "Please enter valid email"
        }
        
        if email.count == 0 || password.count == 0{
            lblStatus.text = "Please enter valid email or password"
        }
        
        SwiftSpinner.show("Logging in...")
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            //guard let self = self else {return}
            SwiftSpinner.hide()
            if error != nil{
                self.lblStatus.text = error?.localizedDescription
                return
            }
            
            let uid = Auth.auth().currentUser?.uid
            
            self.addKeychainAfterLogin(uid!)
            
            self.lblStatus.text = "Login Sucessfully!"
            self.performSegue(withIdentifier: "dashboardSegue", sender: self)
        }
        
    }
    
}


//
//  CreateAccountController.swift
//  FinalProject-JustScheduleIt
//
//  Created by Huang Ekie on 4/28/21.
//

import UIKit
import Firebase

class CreateAccountController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var txtAgainPassword: UITextField!

    @IBOutlet weak var lblStatus: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.text = ""

        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmFunc(_ sender: Any) {
        guard let email = txtEmail.text else{
            return
        }
        guard let password = txtPassword.text else{
            return
        }
        guard let againPassword = txtAgainPassword.text else{
            return
        }
        
        if email.isValidEmail == false {
            lblStatus.text = "Please enter valid email"
            return
        }
        
        if email.count == 0 || password.count == 0{
            lblStatus.text = "Please enter valid email or password"
            return
        }
        
        if password != againPassword{
            lblStatus.text = "Please enter the same password"
            return
        }
        
    
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil{
                self.lblStatus.text = error?.localizedDescription
                return
            }
            let alertTitle = NSMutableAttributedString(string: "New Account")
            let alertMsg = NSMutableAttributedString(string: "New Account Created Successfully!")
            
            self.displayAlert(title: alertTitle, msg: alertMsg)
        }
    }
    
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

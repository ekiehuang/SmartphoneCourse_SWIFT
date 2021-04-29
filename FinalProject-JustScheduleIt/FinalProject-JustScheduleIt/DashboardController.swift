//
//  CreateListViewController.swift
//  FinalProject-JustScheduleIt
//
//  Created by Huang Ekie on 3/22/21.
//

import UIKit
import Firebase
import CoreLocation
import Alamofire
import SwiftyJSON
import SwiftSpinner
import PromiseKit

class DashboardViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblWeather: UILabel!
    
    @IBOutlet weak var backgroundImg: UIImageView!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        backgroundImg.image = UIImage(named: "lightBackground")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            KeychainService().keychain.delete("uid")
            self.navigationController?.popViewController(animated: true)
        }catch{
            print(error)
        }
    }
    
    
    
    @IBAction func recommendFunc(_ sender: Any) {
        
    }
    
}
    
    //MARK: Get current location and weather
    extension DashboardViewController{
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error.localizedDescription)
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let currentLocation = locations.last{
                let lat = currentLocation.coordinate.latitude
                let lng = currentLocation.coordinate.longitude
            
                updateWeather(lat, lng)
            }
        }
        
        func getLocationUrl(_ lat: CLLocationDegrees, _ lng: CLLocationDegrees) -> String{
            var url = locationUrl
            url.append("?apikey=\(apiKey)")
            url.append("&q=\(lat),\(lng)")
            
            return url
        }
        
        func getCurrentUrl(_ cityKey : String) -> String{
            var url = currentConditionUrl
            url.append(cityKey)
            url.append("?apikey=\(apiKey)")
            
            return url
        }
        
        func getLocationData(_ url : String) -> Promise<(String, String)>{
            return Promise<(String, String)> { seal -> Void in
                
                AF.request(url).responseJSON { (response) in
                    if response.error != nil{
                        seal.reject(response.error!)
                    }
                    let locationJSON : JSON = JSON(response.data as Any)
                    let key = locationJSON["Key"].stringValue
                    let city = locationJSON["LocalizedName"].stringValue
                    
                    seal.fulfill((key, city))
                    
                }
            }
        }
        
        func updateWeather(_ lat : CLLocationDegrees, _ lng: CLLocationDegrees){
            let url = getLocationUrl(lat, lng)
            getLocationData(url)
                .done { (key, city) in
                    self.lblCity.text = city
                    let currentUrl = self.getCurrentUrl(key)
                    AF.request(currentUrl).responseJSON{ response in
                        if response.error != nil{
                            return
                        }
                        let currentWeatherJSON : [JSON] = JSON(response.data).arrayValue
                        self.lblWeather.text = currentWeatherJSON[0]["WeatherText"].stringValue
                    }
                }
                .catch { (error) in
                    print(error.localizedDescription)
                }
        }
    }
    


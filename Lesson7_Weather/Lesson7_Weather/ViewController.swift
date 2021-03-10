//
//  ViewController.swift
//  Lesson7_Weather
//
//  Created by Huang Ekie on 3/3/21.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SwiftSpinner
import PromiseKit

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var futureDaysArr : [FutureWeather] = [FutureWeather]()
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCond: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    
    @IBOutlet weak var lblHighLow: UILabel!
    
    @IBOutlet weak var tblForecast: UITableView!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblForecast.delegate = self
        tblForecast.dataSource = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last{
            let lat = currentLocation.coordinate.latitude
            let lng = currentLocation.coordinate.longitude
        
            updateLocalWeather(lat, lng)
        }
    }
    
    func updateWeatherData(_ url: String) -> Promise<(String, Int)>{
        return Promise<(String, Int)>{ seal -> Void in
            AF.request(url).responseJSON { (response) in
                if response.error != nil{
                    seal.reject(response.error!)
                }
                let currentWeatherJSON : [JSON] = JSON(response.data).arrayValue
                
                let condition = currentWeatherJSON[0]["WeatherText"].stringValue
                let temp = currentWeatherJSON[0]["Temperature"]["Imperial"]["Value"].intValue
                
                seal.fulfill((condition, temp))
        }
    }
    }
    
    func getOneDayCondition(_ url: String) -> Promise<(Int, Int)>{
        return Promise<(Int, Int)> {seal -> Void in
            AF.request(url).responseJSON { (response) in
                if response.error != nil{
                    seal.reject(response.error!)
                }
                let oneDayJSON : JSON = JSON(response.data)
                
                let high = oneDayJSON["DailyForecasts"][0]["Temperature"]["Maximum"]["Value"].intValue
                let low = oneDayJSON["DailyForecasts"][0]["Temperature"]["Minimum"]["Value"].intValue
               
                seal.fulfill((high, low))
        }
        }
    }
   
}
//MARK: Updating weather condition
extension ViewController{
    func updateLocalWeather(_ lat : CLLocationDegrees, _ lng: CLLocationDegrees){
        let url = getLocationUrl(lat, lng)
        getlocationData(url)
            .done { (key, city) in
                //get the city and update
                self.lblCity.text = city
                
                //get the current weather data
                let currentUrl = self.getCurrentUrl(key)
                
                self.updateWeatherData(currentUrl)
                    .done { (currCondition, temp) in
                        self.lblCond.text = currCondition
                        self.lblTemp.text = "\(temp)º"
                    }
                    .catch { (error) in
                        print(error.localizedDescription)
                    }
                //get the high and low temperature
                let oneDayUrl = self.getOneDayUrl(key)
                self.getOneDayCondition(oneDayUrl)
                    .done { (high, low) in
                        self.lblHighLow.text = "H:\(high)º, L:\(low)º"
                    }
                    .catch { (error) in
                        print(error.localizedDescription)
                    }
                
                //get the forecast Weather
                let futureUrl = self.getForecastUrl(key)
                self.getFuture(futureUrl)
                    .done { (futureDays) in
                        self.futureDaysArr = [FutureWeather]()
                        for day in futureDays{
                            self.futureDaysArr.append(day)
                        }
                        self.tblForecast.reloadData()
                    }
                    .catch { (error) in
                        print(error.localizedDescription)
                    }
            }
            .catch { (error) in
                print(error.localizedDescription)
            }
    }
    
}

//MARK: Getting the location URL
extension ViewController{
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
    
    func getOneDayUrl(_ cityKey : String) -> String{
        var url = oneDayUrl
        url.append(cityKey)
        url.append("?apikey=\(apiKey)")
        
        return url
    }
    
    func getForecastUrl(_ cityKey : String) -> String{
        var url = forecastUrl
        url.append(cityKey)
        url.append("?apikey=\(apiKey)")
        
        return url
    }
}

//MARK: Promises for getting key and city
extension ViewController{
    func getlocationData(_ url : String) -> Promise<(String, String)>{
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
    
    //Promise for getting future data
    func getFuture(_ url : String) -> Promise<[FutureWeather]>{
        return Promise<[FutureWeather]> {seal -> Void in
            AF.request(url).responseJSON { (response) in
                if response.error != nil{
                    seal.reject(response.error!)
                }
                
                var arr = [FutureWeather]()
                let data : JSON = JSON(response.data)
                guard let futureDays = JSON(data)["DailyForecasts"].array else{return}
                self.futureDaysArr = [FutureWeather]()
                
                for day in futureDays{
                    let responseDate = day["Date"].stringValue
                    
                    let dateFormatter = ISO8601DateFormatter()
                    guard let date = dateFormatter.date(from:responseDate) else{
                        return
                    }
                    
                    let df = DateFormatter()
                    let weekDay = df.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
                    
                    let high = day["Temperature"]["Maximum"]["Value"].intValue
                    let low = day["Temperature"]["Minimum"]["Value"].intValue
                    
                    let day = FutureWeather(date: weekDay, high: high, low: low)
                    arr.append(day)
                }
                seal.fulfill(arr)
        }//end of AF
      } //end of promise
    }//end of func
}

extension ViewController{
    //MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return futureDaysArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell


        cell.lblDayWeek.text = self.futureDaysArr[indexPath.row].date

        let futureHigh = self.futureDaysArr[indexPath.row].high
        let futureLow = self.futureDaysArr[indexPath.row].low

        cell.lblFutureTemp.text = "High:\(futureHigh)º, Low:\(futureLow)º"

        return cell
    }
}

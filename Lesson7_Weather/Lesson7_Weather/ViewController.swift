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
    let imageArr = ["01-s","02-s","03-s","04-s","05-s","06-s","07-s", "08-s","09-s","10-s","11-s","12-s","13-s","14-s","15-s","16-s","17-s","18-s","19-s","20-s","21-s","22-s","23-s","24-s","25-s","26-s","27-s","28-s","29-s","30-s","31-s","32-s","33-s","34-s","35-s","36-s","37-s","38-s","39-s","40-s","41-s","42-s","43-s","44-s"]
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCond: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    
    @IBOutlet weak var lblHigh: UILabel!
    @IBOutlet weak var lblLow: UILabel!
    
    @IBOutlet weak var highImage: UIImageView!
    @IBOutlet weak var lowImage: UIImageView!
    
    @IBOutlet weak var tblForecast: UITableView!
    
    @IBOutlet weak var lblCurWeatherIcon: UIImageView!
    
    
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
    
    func updateWeatherData(_ url: String) -> Promise<(String, Int, Int)>{
        return Promise<(String, Int, Int)>{ seal -> Void in
            AF.request(url).responseJSON { (response) in
                if response.error != nil{
                    seal.reject(response.error!)
                }
                let currentWeatherJSON : [JSON] = JSON(response.data).arrayValue
                
                let condition = currentWeatherJSON[0]["WeatherText"].stringValue
                let temp = currentWeatherJSON[0]["Temperature"]["Imperial"]["Value"].intValue
                let weatherIcon = currentWeatherJSON[0]["WeatherIcon"].intValue
                
                seal.fulfill((condition, temp, weatherIcon))
        }
    }
    }
    
    func getOneDayCondition(_ url: String) -> Promise<(Int, Int, Int, Int)>{
        return Promise<(Int, Int, Int, Int)> {seal -> Void in
            AF.request(url).responseJSON { (response) in
                if response.error != nil{
                    seal.reject(response.error!)
                }
                let oneDayJSON : JSON = JSON(response.data)
                
                let high = oneDayJSON["DailyForecasts"][0]["Temperature"]["Maximum"]["Value"].intValue
                let low = oneDayJSON["DailyForecasts"][0]["Temperature"]["Minimum"]["Value"].intValue
                let dayIcon = oneDayJSON["DailyForecasts"][0]["Day"]["Icon"].intValue
                let nightIcon = oneDayJSON["DailyForecasts"][0]["Night"]["Icon"].intValue
                
                seal.fulfill((high, low, dayIcon, nightIcon))
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
                    .done { (currCondition, temp, weatherIcon) in
                        self.lblCond.text = currCondition
                        self.lblTemp.text = "\(temp)º"
                        self.lblCurWeatherIcon.image = UIImage(named: self.imageArr[weatherIcon-1])
                        print(weatherIcon)
                    }
                    .catch { (error) in
                        print(error.localizedDescription)
                    }
                //get the high and low temperature
                let oneDayUrl = self.getOneDayUrl(key)
                self.getOneDayCondition(oneDayUrl)
                    .done { (high, low, dayIcon, nightIcon) in
                        self.lblHigh.text = "H:\(high)º"
                        self.lblLow.text = "L:\(low)º"
                        self.highImage.image = UIImage(named: self.imageArr[dayIcon-1])
                        self.lowImage.image = UIImage(named: self.imageArr[nightIcon-1])
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
                    let highIcon = day["Day"]["Icon"].intValue
                    let lowIcon = day["Night"]["Icon"].intValue
                    
                    let day = FutureWeather(date: weekDay, high: high, low: low, highIcon: highIcon, lowIcon: lowIcon)
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
        let futureHighIcon = self.futureDaysArr[indexPath.row].highIcon
        let futureLowIcon = self.futureDaysArr[indexPath.row].lowIcon

        cell.lblCellHigh.text = "H:\(futureHigh)º"
        cell.imageCellHigh.image = UIImage(named: self.imageArr[futureHighIcon-1])
        cell.imageCellLow.image = UIImage(named: self.imageArr[futureLowIcon-1])
        cell.lblCellLow.text = "L:\(futureLow)º"

        return cell
    }
}

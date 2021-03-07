//
//  futureWeather.swift
//  Lesson7_Weather
//
//  Created by Huang Ekie on 3/5/21.
//

import Foundation

class FutureWeather {
    var date : String = ""
    var high : Int = 0
    var low : Int = 0
    
    init(date: String, high : Int, low: Int) {
        self.date = date
        self.high = high
        self.low = low
    }
}
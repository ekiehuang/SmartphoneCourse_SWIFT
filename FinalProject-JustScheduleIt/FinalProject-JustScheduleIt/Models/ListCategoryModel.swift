//
//  ListCategoryModel.swift
//  FinalProject-JustScheduleIt
//
//  Created by Huang Ekie on 4/20/21.
//

import Foundation

class ListCategoryModel {
    var categoryID : String = ""
    var content : String = ""
    var priority : Int = 1
    var location : String = ""
    var duration : Double = 1.0
    var condition : Int = 1
    
    init(categoryID : String, content : String, priority : Int, location : String, duration : Double, condition : Int) {
        self.categoryID = categoryID
        self.content = content
        self.priority = priority
        self.location = location
        self.duration = duration
        self.condition = condition
    }
    
    
}

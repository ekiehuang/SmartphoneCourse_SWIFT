//
//  ToDoList.swift
//  FinalProject-JustScheduleIt
//
//  Created by Huang Ekie on 3/22/21.
//

import Foundation

class ToDoList{
    var title : String
    var priority : String
    var durationPerTime : Float
    var location : String
    var minCondition : String
    
    init(title : String, priority : String, durationPerTime : Float, location : String, minCondition : String) {
        self.title = title
        self.priority = priority
        self.durationPerTime = durationPerTime
        self.location = location
        self.minCondition = minCondition
    }
}

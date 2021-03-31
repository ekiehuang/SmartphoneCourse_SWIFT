//
//  Covid.swift
//  Mid-Term Test
//
//  Created by Huang Ekie on 3/30/21.
//

import Foundation

class Covid{
    var state : String
    var total : Int
    var positive : Int
    
    init(state: String, total : Int, positive : Int) {
        self.state = state
        self.total = total
        self.positive = positive
    }
}

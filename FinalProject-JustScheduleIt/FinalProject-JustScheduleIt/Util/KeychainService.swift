//
//  KeychainService.swift
//  FinalProject-JustScheduleIt
//
//  Created by Huang Ekie on 4/10/21.
//

import Foundation
import KeychainSwift

class KeychainService{
    var _localVar = KeychainSwift()
    
    var keychain : KeychainSwift{
        get{
            return _localVar
        }
        set{
            _localVar = newValue
        }
    }
}

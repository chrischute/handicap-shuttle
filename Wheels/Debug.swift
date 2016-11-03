//
//  Debug.swift
//  Wheels
//
//  Created by Christopher Chute on 10/31/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import Foundation

/* Functions for debugging and logging. */
class Debug {
    static let is_debug_build = true
    
    class func log(_ str: String) {
        if Debug.is_debug_build {
            print("Error: " + str)
        }
    }
}

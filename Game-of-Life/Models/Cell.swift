//
//  Cell.swift
//  Game-of-Life
//
//  Created by Gi Pyo Kim on 7/27/20.
//  Copyright © 2020 gipgip. All rights reserved.
//

import Foundation
import SwiftUI

struct Cell: Hashable {
    var id: Int
    var alive: Bool = false
    var generation: Int = 0
    
    
    static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.id == rhs.id
    }
}

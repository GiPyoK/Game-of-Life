//
//  Cell.swift
//  Game-of-Life
//
//  Created by Gi Pyo Kim on 7/27/20.
//  Copyright © 2020 gipgip. All rights reserved.
//

import Foundation

struct Cell {
    var alive: Bool = false
    var generation: Int = 0
    let x: Int
    let y: Int
}

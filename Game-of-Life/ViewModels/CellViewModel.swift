//
//  CellViewModel.swift
//  Game-of-Life
//
//  Created by Gi Pyo Kim on 7/27/20.
//  Copyright © 2020 gipgip. All rights reserved.
//

import Foundation
import SwiftUI

class CellViewModel: ObservableObject {
    @Published var cells = [Cell]()
    
    private var grid: Int?
    
    private var NEIGHBORS: [Int] {
        guard let grid = grid else { return [] }
        return [ -grid-1, -1, grid-1,
                 -grid,       grid,
                 -grid+1,  1, grid+1 ]
    }
    
    var columns = [GridItem]()
    
    init(grid: Int = 20) {
        drawSquareGrid(grid: grid)
    }
    
    func drawSquareGrid(grid: Int) {
        self.grid = grid
        var id = 0
        for _ in 0...grid {
            columns.append(GridItem(.flexible()))
            for _ in 0...grid {
                cells.append(Cell(id: id))
                id += 1
            }
        }
    }
    
    func getNumOfNeighbors(cell: Cell) -> Int{
        var count = 0
        for neighbor in NEIGHBORS {
            if isAlive(id: cell.id + neighbor) {
                count += 1
            }
        }
        return count
    }
    
    private func isAlive(id: Int) -> Bool {
        guard let grid = grid else { return false }
        
        if id >= 0 && id < (grid*grid) {
            return cells[id].alive
        } else {
            return false
        }
    }
}

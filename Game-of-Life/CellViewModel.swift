//
//  CellViewModel.swift
//  Game-of-Life
//
//  Created by Gi Pyo Kim on 7/27/20.
//  Copyright © 2020 gipgip. All rights reserved.
//

import Foundation

class CellViewModel {
    @Published var cells = [[Cell]]()
    
    private var grid: Int?
    
    private let NEIGHBORS = [
        (-1, -1), (-1, 0), (-1, 1),
        (0, -1),            (0, 1),
        (1, -1),  (1, 0),   (1, 1)
        ]
    
    func drawSquareGrid(grid: Int) {
        self.grid = grid
        for i in 0...grid {
            for j in 0...grid {
                cells[i][j] = Cell(x: i, y: j)
            }
        }
    }
    
    func getNumOfNeighbors(cell: Cell) -> Int{
        var count = 0
        for neighbor in NEIGHBORS {
            if isAlive(x: cell.x + neighbor.0, y: cell.y + neighbor.1) {
                count += 1
            }
        }
        return count
    }
    
    private func isAlive(x: Int, y: Int) -> Bool {
        guard let grid = grid else { return false }
        
        if x >= 0 && x < grid && y >= 0 && y < grid {
            return cells[x][y].alive
        } else {
            return false
        }
    }
}

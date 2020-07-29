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
    
    init(grid: Int = 5) {
        drawSquareGrid(grid: grid)
    }
    
    func toggleCell(cell: Cell) {
        if cell.id >= 0 && cell.id < cells.count {
            cells[cell.id].alive.toggle()
        }
    }
    
    func drawSquareGrid(grid: Int) {
        self.grid = grid
        var id = 0
        for _ in 0..<grid {
            columns.append(GridItem(.flexible()))
            for _ in 0..<grid {
                cells.append(Cell(id: id))
                id += 1
            }
        }
    }
    
    func setNumOfNeighbors(cell: Cell) {
        var neighbors = 0
        for neighbor in NEIGHBORS {
            if isAlive(id: cell.id + neighbor) {
                neighbors += 1
            }
        }
        cells[cell.id].neighbors = neighbors
    }
    
    private func isAlive(id: Int) -> Bool {
        guard let grid = grid else { return false }
        
        if id >= 0 && id < (grid*grid) {
            return cells[id].alive
        } else {
            return false
        }
    }
    
    private func isDead(id: Int) -> Bool {
        guard let grid = grid else { return false }
        
        if id >= 0 && id < (grid*grid) {
            return cells[id].alive == false
        } else {
            return false
        }
    }
    
    private func killCell(id: Int) {
        guard let grid = grid else { return }
        
        if id >= 0 && id < (grid*grid) {
            cells[id].alive = false
            cells[id].generation = 0
            cells[id].neighbors = 0
        }
    }
    
    private func liveNextGenCell(id: Int) {
        guard let grid = grid else { return }
        
        if id >= 0 && id < (grid*grid) {
            cells[id].generation += 1
        }
    }
    
    private func resurrectCell(id: Int) {
        guard let grid = grid else { return }
        
        if id >= 0 && id < (grid*grid) {
            cells[id].alive = true
            cells[id].generation = 0
            cells[id].neighbors = 0
        }
    }
}

// Main Game Logic
extension CellViewModel {
    func main() {
        // get live cells
        let liveCells = cells.filter() { $0.alive == true }
        var deadNeighborCells: [Cell] {
            var deadNeighborsArr: [Cell] = []
            
            for liveCell in liveCells {
                for neighbor in NEIGHBORS {
                    if isDead(id: liveCell.id + neighbor) {
                        deadNeighborsArr.append(cells[liveCell.id + neighbor])
                    }
                }
            }
            return Array(Set(deadNeighborsArr))
        }
        // calculate the number of neighbors
        for cell in liveCells {
            setNumOfNeighbors(cell: cell)
        }
        
        // Any live cell with fewer than two live neighbours dies, as if by underpopulation.
        // Any live cell with more than three live neighbours dies, as if by overpopulation.
        for willDieCell in liveCells.filter({ $0.neighbors < 2 || $0.neighbors > 3 }) {
            killCell(id: willDieCell.id)
        }
        
        // Any live cell with two or three live neighbours lives on to the next generation.
        for willLiveCell in liveCells.filter({ $0.neighbors == 2 || $0.neighbors == 3 }) {
            liveNextGenCell(id: willLiveCell.id)
        }
        
        // Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
        for willLiveCell in deadNeighborCells {
            resurrectCell(id: willLiveCell.id)
        }
        
    }
}

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
    @Published var gameSpeed: Double = 1
    @Published var isPlaying: Bool = false
    var columns = [GridItem]()
    var mainTimer: Timer?
    var grid: Int?
    
    private var NEIGHBORS: [Int] {
        guard let grid = grid else { return [] }
        return [ -grid-1, -grid, -grid+1,
                 -1, 1,
                 grid-1,  grid, grid+1 ]
    }
    
    init(grid: Int = 10) {
        drawSquareGrid(grid: grid)
    }
    
    func updateLoopSpeed(speed: Double) {
        if speed > 0 {
            gameSpeed = speed
        }
    }
    
    func togglePlay() {
        isPlaying.toggle()
        play()
    }
    
    func reset() {
        isPlaying = false
        play()
        for cell in cells {
            cells[cell.id].alive = false
            cells[cell.id].generation = 0
            cells[cell.id].neighbors = 0
        }
    }
    
    func toggleCell(cell: Cell) {
        if cell.id >= 0 && cell.id < cells.count {
            cells[cell.id].alive.toggle()
        }
    }
    
    func drawSquareGrid(grid: Int) {
        // re-initialize the grid, cells and columns
        self.grid = grid
        cells = [Cell]()
        columns = [GridItem]()
        
        var id = 0
        for _ in 0..<grid {
            columns.append(GridItem(.adaptive(minimum: 100)))
            for _ in 0..<grid {
                cells.append(Cell(id: id))
                id += 1
            }
        }
    }
    
    func setNumOfNeighbors(cell: Cell) {
        guard let grid = grid else { return }
        let id = cell.id
        var edgeNeighbors = NEIGHBORS
        
        // Check for the edges of the grid
        // Top of the Grid
        if (0 ..< grid).contains(id) {
            edgeNeighbors[0] = 0
            edgeNeighbors[1] = 0
            edgeNeighbors[2] = 0
        }
        // Bottom of the Grid
        else if ((grid*grid - grid) ..< (grid*grid)).contains(id) {
            edgeNeighbors[5] = 0
            edgeNeighbors[6] = 0
            edgeNeighbors[7] = 0
        }
        // Left of the Grid
        if id == 0 || id%grid == 0 {
            edgeNeighbors[0] = 0
            edgeNeighbors[3] = 0
            edgeNeighbors[5] = 0
        }
        // Right of the Grid
        else if (id + 1)%grid == 0 {
            edgeNeighbors[2] = 0
            edgeNeighbors[4] = 0
            edgeNeighbors[7] = 0
        }
        // remove 0's
        edgeNeighbors.removeAll { $0 == 0 }
        
        var neighbors = 0
        for neighbor in edgeNeighbors {
            if isAlive(id: id + neighbor) {
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
            cells[id].alive = true
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
    
    private func getLiveCells() -> [Cell] {
        return cells.filter() { $0.alive == true }
    }
    
    private func getDeadNeightborCells() -> [Cell] {
        var deadNeighborsArr: [Cell] = []
        
        for liveCell in getLiveCells() {
            for neighbor in NEIGHBORS {
                if isDead(id: liveCell.id + neighbor) {
                    deadNeighborsArr.append(cells[liveCell.id + neighbor])
                }
            }
        }
        return Array(Set(deadNeighborsArr))
    }
}

// Main Game Logic
extension CellViewModel {
    func main() {
        // calculate the neighbors of live cells
        for cell in getLiveCells() {
            setNumOfNeighbors(cell: cell)
        }
        
        // calculate the neighbors of dead cells
        for cell in getDeadNeightborCells() {
            setNumOfNeighbors(cell: cell)
        }
        
        // Copy cells
        let liveCells = getLiveCells()
        let deadCells = getDeadNeightborCells()
        
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
        for deadCell in deadCells {
            if deadCell.neighbors == 3 {
                resurrectCell(id: deadCell.id)
            }
        }
        
    }
    
    private func play() {
        
        if isPlaying{
            mainTimer = Timer.scheduledTimer(withTimeInterval: gameSpeed, repeats: true) { _ in
                self.main()
            }
        } else {
            mainTimer?.invalidate()
        }
            
    }
}

// Presets
extension CellViewModel {
    func makeGosperGliderGun() {
        let grid = 40
        var activeCells = [
            24+(grid),
            22+(grid*2), 24+(grid*2),
            12+(grid*3), 13+(grid*3), 20+(grid*3), 21+(grid*3), 34+(grid*3), 35+(grid*3),
            11+(grid*4), 15+(grid*4), 20+(grid*4), 21+(grid*4), 34+(grid*4), 35+(grid*4),
            0+(grid*5), 1+(grid*5), 10+(grid*5), 16+(grid*5), 20+(grid*5), 21+(grid*5),
            0+(grid*6), 1+(grid*6), 10+(grid*6), 14+(grid*6), 16+(grid*6), 17+(grid*6), 22+(grid*6), 24+(grid*6),
            10+(grid*7), 16+(grid*7), 24+(grid*7),
            11+(grid*8), 15+(grid*8),
            12+(grid*9), 13+(grid*9)
        ]
        
        drawSquareGrid(grid: grid)
        isPlaying = false
        
        for i in 0..<activeCells.count {
            activeCells[i] += 1
        }
        
        for cellID in activeCells {
            cells[cellID].alive = true
        }
    }
    
    func randomCell() {
        reset()
        for i in 0..<cells.count {
            cells[i].alive = Bool.random()
        }
    }
}

//
//  ContentView.swift
//  Game-of-Life
//
//  Created by Gi Pyo Kim on 7/27/20.
//  Copyright © 2020 gipgip. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var cellVM = CellViewModel()
    
    @State var grid: Float = 10
    @State var gameSpeed: Double = 1
    
    var body: some View {
        GeometryReader { geometry in
        VStack {
            
            Heading()
            
            // Grid slider
            HStack {
                Text("Grid: \(Int(grid)) x \(Int(grid))")
                Slider(value: $grid, in: 5...30, step: 1) { _ in
                    cellVM.drawSquareGrid(grid: Int(grid))
                }
                .allowsHitTesting(!cellVM.isPlaying)
            }.padding()
            
            // Game grid
            LazyVGrid(columns: cellVM.columns, spacing: 1) {
                let cellWidth = (geometry.size.width / CGFloat(Double(grid)/2.0)) / 2.0
                ForEach(cellVM.cells, id: \.id) { cell in
                    Rectangle()
                        .frame(width: cellWidth, height: cellWidth, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(cell.alive ? Color.green : Color.red)
                        .gesture(TapGesture(count: 1)
                                    .onEnded { _ in
                                        cellVM.toggleCell(cell: cell)
                                    })
                        .allowsHitTesting(!cellVM.isPlaying)
                }
            }.frame(width: geometry.size.width,
                    height: geometry.size.width)
            
            // Game speed slider
            HStack {
                Text(String(format: "Update generation every %.2f seconds", gameSpeed))
                Slider(value: $gameSpeed, in: 0.01...2, step: 0.01) { _ in
                    cellVM.updateLoopSpeed(speed: gameSpeed)
                }
                .allowsHitTesting(!cellVM.isPlaying)
            }.padding()
            
            // Play buttons
            HStack {
                Button(action: {
                    cellVM.togglePlay()
                }) {
                    Image(systemName: !cellVM.isPlaying ? "play.circle.fill" : "pause.circle.fill")
                        .font(.title)
                }
                
                Button(action: {
                    cellVM.reset()
                }) {
                    Image(systemName: "stop.circle.fill")
                        .font(.title)
                }
            }.padding()
        }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Heading: View {
    var body: some View {
        HStack {
            Text("Conway's Game Of Life")
                .font(.title)
            Spacer()
            Button(action: {
                
            }) {
                Image(systemName: "info.circle.fill")
                    .font(.title)
            }
        }.padding()
    }
}

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
    
    @State var grid: Int = 5
    
    var body: some View {
        GeometryReader { geometry in
        VStack {
            
            Heading()
            
            HStack {
                Text("Construct a square grid:")
                TextField("grid x grid", value: $grid, formatter: NumberFormatter()) {
                    cellVM.drawSquareGrid(grid: grid)
                }
            }.padding()
            
            
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
                }
            }.frame(width: geometry.size.width,
                    height: geometry.size.width)
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
                .font(.largeTitle)
            Spacer()
            Button(action: {
                
            }) {
                Image(systemName: "info.circle.fill")
                    .font(.title)
            }
        }.padding()
    }
}

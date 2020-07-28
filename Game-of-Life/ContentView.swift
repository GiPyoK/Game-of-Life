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
    
    @State var grid: Int = 20
    
    var body: some View {
        VStack {
            
            Heading()
            
            HStack {
                Text("Construct a square grid:")
                TextField("grid", value: $grid, formatter: NumberFormatter()) {
                    cellVM.drawSquareGrid(grid: grid)
                }
            }.padding()
            
            ScrollView {
                LazyVGrid(columns: cellVM.columns, spacing: 2) {
                    ForEach(cellVM.cells, id: \.id) { cell in
                        Rectangle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(cell.alive ? Color.green : Color.red)
                    }
                }
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

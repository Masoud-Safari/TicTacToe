//
//  ContentView.swift
//  TicTacToe
//
//  Created by Masoud Safari on 2024-02-23.
//

import Observation
import SwiftUI

enum Player: CaseIterable {
    case x, o
}

struct Line: View {
    var startPoint: CGPoint
    var endPoint: CGPoint
    
    var body: some View {
        var path = Path()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        return path.stroke(Color.black, lineWidth: 2)
    }
}

struct BoardView: View {
    let board: [Player?]
    var click: (Int) -> Void
    
    init(_ board: [Player?], click: @escaping (Int) -> Void) {
        self.board = board
        self.click = click
    }
    
    var body: some View {
        ZStack {
            Line(startPoint: CGPoint(x: 80, y: 40), endPoint: CGPoint(x: 80, y: 160))
            Line(startPoint: CGPoint(x: 120, y: 40), endPoint: CGPoint(x: 120, y: 160))
            Line(startPoint: CGPoint(x: 40, y: 80), endPoint: CGPoint(x: 160, y: 80))
            Line(startPoint: CGPoint(x: 40, y: 120), endPoint: CGPoint(x: 160, y: 120))
            
            ForEach(0..<3) { i in
                ForEach(0..<3) { j in
                    Button {
                        click(3 * j + i)
                    } label: {
                        if let a = board[3 * j + i] {
                            if a == .x {
                                Image(systemName: "xmark")
                                    .font(.largeTitle)
                                    .foregroundStyle(.red)
                            } else {
                                Image(systemName: "circle")
                                    .font(.largeTitle)
                                    .foregroundStyle(.blue)
                            }
                        } else {
                            Color(red: 239/255, green: 239/255, blue: 239/255)
                                .frame(width: 38, height: 38)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(4)
                    .offset(x: 40 * CGFloat(i) - 40, y: 40 * CGFloat(j) - 40)
                    .focusEffectDisabled()
                }
            }
        }
        .frame(width: 200, height: 200)
        .preferredColorScheme(.light)
    }
}

struct ContentView: View {
    @State private var board: [Player?] = [.x, nil, .x, nil, .o, .o, nil, nil, nil]
    
    var body: some View {
        BoardView(board) { x in
            print(x)
        }
    }
}

#Preview {
    ContentView()
}

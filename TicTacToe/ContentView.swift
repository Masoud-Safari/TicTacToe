//
//  ContentView.swift
//  TicTacToe
//
//  Created by Masoud Safari on 2024-02-23.
//

import Observation
import SwiftUI

// Draw a line with given start and end point
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

// Draw the game board based on the current state of given game.
struct BoardView: View {
    let ticTacToe: TicTacToe
    var click: (Int) -> Void
    
    let message: String
    let messageColor: Color
    
    init(_ ticTacToe: TicTacToe, click: @escaping (Int) -> Void) {
        self.ticTacToe = ticTacToe
        self.click = click
        if ticTacToe.root.gameState == .o {
            self.message = "You Lost!"
            self.messageColor = .red
        } else if ticTacToe.root.gameState == .x {
            self.message = "You Won!"
            self.messageColor = .green
        } else if ticTacToe.root.gameState == .draw {
            self.message = "Draw!"
            self.messageColor = .black
        } else {
            self.message = ""
            self.messageColor = .black
        }
    }
    
    var body: some View {
        ZStack {
            Color.white
            
            Text(message)
                .foregroundStyle(messageColor)
                .font(.headline)
                .offset(y: -80)
            
            Line(startPoint: CGPoint(x: 80, y: 40), endPoint: CGPoint(x: 80, y: 160))
            Line(startPoint: CGPoint(x: 120, y: 40), endPoint: CGPoint(x: 120, y: 160))
            Line(startPoint: CGPoint(x: 40, y: 80), endPoint: CGPoint(x: 160, y: 80))
            Line(startPoint: CGPoint(x: 40, y: 120), endPoint: CGPoint(x: 160, y: 120))
            
            ForEach(0..<3) { i in
                ForEach(0..<3) { j in
                    Button {
                        click(3 * j + i)
                    } label: {
                        if let a = self.ticTacToe.root.state[3 * j + i] {
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
                            Color.white
                                .frame(width: 38, height: 38)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(4)
                    .offset(x: 40 * CGFloat(i) - 40, y: 40 * CGFloat(j) - 40)
                    .focusEffectDisabled()
                }
            }
            
            if let winComb = self.ticTacToe.root.winCombination {
                Line(
                    startPoint: CGPoint(x: 40 * CGFloat(winComb[0] % 3) + 60, y: 40 * CGFloat(winComb[0] / 3) + 60),
                    endPoint: CGPoint(x: 40 * CGFloat(winComb[2] % 3) + 60, y: 40 * CGFloat(winComb[2] / 3) + 60)
                )
            }
        }
        .frame(width: 200, height: 200)
        .preferredColorScheme(.light)
    }
}

struct ContentView: View {
    @State private var game: TicTacToe
    
    init() {
        self.game = TicTacToe(firstPlayer: .x)
    }
    
    var body: some View {
        ZStack {
            BoardView(game) { cell in
                game.play(cell)
            }
            
            Button("Reset") {
                self.game = TicTacToe(firstPlayer: Player.allCases.randomElement()!)
            }
            .offset(y: 80)
        }
    }
}

#Preview {
    ContentView()
}

//
//  TicTacTieGame.swift
//  TicTacToe
//
//  Created by Masoud Safari on 2024-03-04.
//

import Foundation

enum Player: CaseIterable {
    case x, o
}


enum GameState {
    case notFinished, draw, x, o
}


class Board {
    var state: [Player?]
    var nextStates: [Board] = []
    var nextPlayer: Player
    var gameState: GameState = .notFinished
    var winCombination: [Int]? = nil
    private var _score: Int? = nil
    
    var score: Int {
        if let score = _score {
            return score
        }
        
        if self.gameState == .draw {
            self._score = 0
            return 0
        }
        
        if self.gameState == .o {
            self._score = 1
            return 1
        }
        
        if self.gameState == .x {
            self._score = -1
            return -1
        }
        
        var scores: [Int] = []
        for board in nextStates {
            scores.append(board.score)
        }
        
        if nextPlayer == .o {
            return scores.max() ?? 0
        }
        
        return scores.min() ?? 0
    }
    
    init(_ board: [Player?], nextPlayer: Player) {
        self.state = board
        self.nextPlayer = nextPlayer
        self.setGameState()
        self.nextStates = self.getNextStates()
    }
    
    func setGameState() {
        let winCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                               [0, 3, 6], [1, 4, 7], [2, 5, 8],
                               [0, 4, 8], [2, 4, 6]]
        
        for winCombination in winCombinations {
            if self.state[winCombination[0]] == self.state[winCombination[1]] &&
                self.state[winCombination[1]] == self.state[winCombination[2]] {
                if self.state[winCombination[0]] == .o {
                    self.gameState = .o
                    self.winCombination = winCombination
                    return
                } else if self.state[winCombination[0]] == .x {
                    self.gameState = .x
                    self.winCombination = winCombination
                    return
                }
            }
        }
        
        for cell in self.state {
            if cell == nil {
                self.gameState = .notFinished
                return
            }
        }
        
        self.gameState = .draw
        return
    }
    
    func getNextStates() -> [Board] {
        var result: [Board] = []
        if gameState == .notFinished {
            let nextNextPlayer: Player = nextPlayer == .o ? .x : .o
            
            for i in 0..<9 {
                if state[i] == nil {
                    var tempState = self.state
                    tempState[i] = nextPlayer
                    let newState = Board(tempState, nextPlayer: nextNextPlayer)
                    result.append(newState)
                }
            }
        }
        return result
    }
}

@Observable
class TicTacToe: CustomStringConvertible {
    var root: Board
    
    init(firstPlayer: Player) {
        self.root = Board([nil, nil, nil, nil, nil, nil, nil, nil, nil], nextPlayer: firstPlayer == .o ? .o : .x)
        
        if firstPlayer == .o {
            let nextMoveNumber = (0..<9).randomElement()!
            self.root = self.root.nextStates[nextMoveNumber]
        }
    }
    
    var description: String {
        let p: [String] = self.root.state.map({ c in
            if let c = c {
                if c == .x {
                    return "x"
                } else {
                    return "o"
                }
            } else {
                return " "
            }
        })
        
        return "\(p[0])|\(p[1])|\(p[2])\n\(p[3])|\(p[4])|\(p[5])\n\(p[6])|\(p[7])|\(p[8])\n"
    }
    
    func play(_ cellNumber: Int) {
        guard self.root.gameState == .notFinished else {
            return
        }
        
        if self.root.state[cellNumber] == nil {
            // Next player move
            for s in self.root.nextStates {
                if s.state[cellNumber] == .x {
                    self.root = s
                    break
                }
            }
            
            guard self.root.gameState == .notFinished else {
                return
            }
            
            // Next computer move
            
            // Check for win condition
            for i in 0..<self.root.nextStates.count {
                if self.root.nextStates[i].gameState == .o {
                    self.root = self.root.nextStates[i]
                    return
                }
            }
            
            // If there were no win condition, check for score 1
            var nextMoveIndices: [Int] = []
            for i in 0..<self.root.nextStates.count {
                if self.root.nextStates[i].score == 1 {
                    nextMoveIndices.append(i)
                }
            }
            
            // If there were no socre 1, check for score 0
            if nextMoveIndices.count == 0 {
                for i in 0..<self.root.nextStates.count {
                    if self.root.nextStates[i].score == 0 {
                        nextMoveIndices.append(i)
                    }
                }
            }
            
            self.root = self.root.nextStates[nextMoveIndices.randomElement()!]
        }
    }
}

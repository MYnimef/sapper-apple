//
//  Field.swift
//  sapper
//
//  Created by Ivan Markov on 28.02.2022.
//

import Foundation


class Game: ObservableObject {
    
    @Published var field: [CellLine]
    
    private let width: Int = 9
    private let height: Int = 9
    private let minesAmount: Int = 10
    
    init() {
        field = []
        for i in 0 ..< height {
            let line: CellLine = CellLine()
            for j in 0 ..< width {
                line.addCell(Cell(onClosedAction: { cell in
                    self.generateMines(tappedY: i, tappedX: j)
                }))
            }
            field.append(line)
        }
    }
    
    func generateMines(tappedY: Int, tappedX: Int) {
        var y = [Int] (repeating: 0, count: minesAmount)
        var x = [Int] (repeating: 0, count: minesAmount)
        
        var i: Int = 0
        while i < minesAmount {
            let y_pos: Int = Int.random(in: 0 ..< height)
            let x_pos: Int = Int.random(in: 0 ..< width)
            
            for j in (0 ..< i).reversed() {
                if y_pos == y[j] && x_pos == x[j] {
                    continue
                }
            }
            
            if checkTapped(y: y_pos, x: x_pos, tappedY: tappedY, tappedX: tappedX) {
                y[i] = y_pos
                x[i] = x_pos
                i += 1
            }
        }
        
        var map = ([[Bool]] (repeating: ([Bool] (repeating: false, count: width + 2)), count: height + 2))
        for i in 0 ..< minesAmount {
            map[y[i] + 1][x[i] + 1] = true
        }
        
        generateCells(map: map, tappedY: tappedY, tappedX: tappedX)
    }
    
    func checkTapped(y: Int, x: Int, tappedY: Int, tappedX: Int) -> Bool {
        for j in -1 ... 1 {
            for k in -1 ... 1 {
                if y == tappedY + j && x == tappedX + k {
                    return false
                }
            }
        }
        return true
    }
    
    func generateCells(map: [[Bool]], tappedY: Int, tappedX: Int) {
        
        var newField: [CellLine] = []
        var prevLine: CellLine?
        
        for i in 0 ..< height {
            
            let line: CellLine = CellLine()
            var prevCell: Cell?
            
            for j in 0 ..< width {
                
                let cell: Cell
                
                if map[i + 1][j + 1] {
                    cell = MineCell(onClosedAction: { i in
                        self.closedMineCellClick(i)
                    })
                } else {
                    var mines: Int = 0
                    
                    for k in -1 ... 1 {
                        for m in -1 ... 1 {
                            if k != 0 || m != 0 {
                                if map[i + k + 1][j + m + 1] {
                                    mines += 1
                                }
                            }
                        }
                    }
                    
                    if mines != 0 {
                        cell = NumberCell(
                            number: String(mines),
                            onClosedAction: { i in
                                self.closedNumberCellClick(i)
                            },
                            onOpenedAction: {
                                
                            }
                        )
                    } else {
                        cell = Cell(onClosedAction: { i in
                            self.closedEmptyCellClick(i)
                        })
                    }
                }
                
                line.addCell(cell)
                
                if let prev = prevLine {
                    cell.makeConnection(prev.getCell(j))
                }
                
                if let prev = prevCell {
                    cell.makeConnection(prev)
                }
                prevCell = cell
            }
            
            newField.append(line)
            prevLine = line
        }
        
        newField[tappedY].getCell(tappedX).open()
        field = newField
    }
    
    func closedEmptyCellClick(_ cell: Cell) {
        if !(cell is NumberCell || cell is MineCell) {
            for i in cell.getConnected() {
                i.open()
            }
        }
    }
    
    func closedNumberCellClick(_ cell: Cell) {
        
    }
    
    func closedMineCellClick(_ cell: Cell) {
        
    }
}

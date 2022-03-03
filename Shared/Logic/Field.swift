//
//  Field.swift
//  sapper
//
//  Created by Ivan Markov on 02.03.2022.
//

import Foundation


class Field: ObservableObject {
    
    private let width: Int
    private let height: Int
    private let minesAmount: Int
    private let setter: (_ field: [CellLine]) -> ()
    
    init(width: Int, height: Int, minesAmount: Int, setter: @escaping (_ field: [CellLine]) -> ()) {
        self.width = width
        self.height = height
        self.minesAmount = minesAmount
        self.setter = setter
    }
    
    public func generateEmptyField() -> [CellLine] {
        var field: [CellLine] = []
        for i in 0 ..< height {
            let line: CellLine = CellLine()
            for j in 0 ..< width {
                line.addCell(Cell(onClosedAction: { cell in
                    let map = self.generateMines(i, j)
                    let field = self.generateCells(map: map, i, j)
                    field[i].getCell(j).open()
                    self.setter(field)
                }))
            }
            field.append(line)
        }
        return field
    }
    
    private func generateMines(_ tappedY: Int, _ tappedX: Int) -> [[Bool]] {
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
        
        return map
    }
    
    private func checkTapped(y: Int, x: Int, tappedY: Int, tappedX: Int) -> Bool {
        for j in -1 ... 1 {
            for k in -1 ... 1 {
                if y == tappedY + j && x == tappedX + k {
                    return false
                }
            }
        }
        return true
    }
    
    private func generateCells(map: [[Bool]], _ tappedY: Int, _ tappedX: Int) -> [CellLine] {
        
        var field: [CellLine] = []
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
                            onOpenedAction: { i in
                                self.openedNumberCellClick(i)
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
                    if j > 0 {
                        cell.makeConnection(prev.getCell(j - 1))
                    }
                    if j < width - 1 {
                        cell.makeConnection(prev.getCell(j + 1))
                    }
                }
                
                if let prev = prevCell {
                    cell.makeConnection(prev)
                }
                prevCell = cell
            }
            
            field.append(line)
            prevLine = line
        }
        
        return field
    }
    
    func closedEmptyCellClick(_ cell: Cell) {
        for i in cell.getConnected() {
            if i.getState() == .closed {
                i.open()
            }
        }
    }
    
    func openedNumberCellClick(_ cell: NumberCell) {
        var count: Int  = 0
        for i in cell.getConnected() {
            if i.getState() == .marked {
                count += 1
            }
        }
        if String(count) == cell.getNumber() {
            for i in cell.getConnected() {
                if i.getState() == .closed {
                    i.open()
                }
            }
        }
    }
    
    func closedMineCellClick(_ cell: Cell) {
        
    }
}

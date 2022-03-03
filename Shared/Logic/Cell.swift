//
//  Cell.swift
//  sapper
//
//  Created by Ivan Markov on 28.02.2022.
//

import Foundation


enum CellState {
    case closed
    case opened
    case marked
}


class Cell: ObservableObject, Identifiable {
    
    @Published private var state: CellState = .closed
    private let onClosedAction: (_ cell: Cell) -> ()
    
    private var connectedCells: [Cell] = []
    
    init(onClosedAction: @escaping (_ cell: Cell) -> ()) {
        self.onClosedAction = onClosedAction
    }
    
    init() {
        self.onClosedAction = { i in }
    }
    
    func getState() -> CellState {
        return state
    }
    
    func open() {
        switch state {
        case .closed:
            state = .opened
            onClosedAction(self)
        case .marked:
            return
        case .opened:
            break
        }
    }
    
    func mark() {
        switch state {
        case .closed:
            state = .marked
        case .opened:
            return
        case .marked:
            state = .closed
        }
    }
    
    func makeConnection(_ cell: Cell) {
        addToConnected(cell)
        cell.addToConnected(self)
    }
    
    private func addToConnected(_ cell: Cell) {
        connectedCells.append(cell)
    }
    
    func getConnected() -> [Cell] {
        return connectedCells
    }
}


class NumberCell: Cell {
    
    private let number: String
    private let onOpenedAction: (_ cell: NumberCell) -> ()
    
    init(number: String, onOpenedAction: @escaping (_ cell: NumberCell) -> ()) {
        self.number = number
        self.onOpenedAction = onOpenedAction
        super.init()
    }
    
    override func open() {
        super.open()
        if getState() == .opened {
            onOpenedAction(self)
        }
    }
    
    func getNumber() -> String {
        return number
    }
}


class MineCell: Cell {
    
}


class CellLine: Identifiable {
    
    private var line: [Cell]
    
    init() {
        self.line = []
    }
    
    func addCell(_ cell: Cell) {
        line.append(cell)
    }
    
    func getLine() -> [Cell] {
        return line
    }
    
    func getCell(_ pos: Int) -> Cell {
        return line[pos]
    }
}

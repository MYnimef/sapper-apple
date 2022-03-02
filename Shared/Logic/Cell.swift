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
    private let onOpenedAction: () -> ()
    
    private var connectedCells: [Cell] = []
    
    init(onClosedAction: @escaping (_ cell: Cell) -> ()) {
        self.onClosedAction = onClosedAction
        self.onOpenedAction = {}
    }
    
    fileprivate init(
        onClosedAction: @escaping (_ cell: Cell) -> (),
        onOpenedAction: @escaping () -> ()
    ) {
        self.onClosedAction = onClosedAction
        self.onOpenedAction = onOpenedAction
    }
    
    func getState() -> CellState {
        return state
    }
    
    func open() {
        switch state {
        case .closed:
            state = .opened
            onClosedAction(self)
        case .opened:
            onOpenedAction()
        case .marked:
            return
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
    
    func getContent() -> String {
        return ""
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
    
    init(
        number: String,
        onClosedAction: @escaping (_ cell: Cell) -> (),
        onOpenedAction: @escaping () -> ()
    ) {
        self.number = number
        super.init(onClosedAction: onClosedAction, onOpenedAction: onOpenedAction)
    }
    
    override func getContent() -> String {
        return number
    }
}


class MineCell: Cell {
    
    override func getContent() -> String {
        return "M"
    }
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

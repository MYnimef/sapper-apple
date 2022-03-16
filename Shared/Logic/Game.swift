//
//  Field.swift
//  sapper
//
//  Created by Ivan Markov on 28.02.2022.
//

import Foundation


final class Game: ObservableObject {
    
    @Published var field: [CellLine] = []
    
    private let width: Int = 9
    private let height: Int = 9
    private let minesAmount: Int = 10
    
    init() {
        newGame()
    }
    
    private func setField(_ field: [CellLine]) {
        self.field = field
    }
    
    func newGame() {
        field = Field(
            width: width,
            height: height,
            minesAmount: minesAmount,
            setter: setField
        )
            .generateEmptyField()
    }
}

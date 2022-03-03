//
//  macOSView.swift
//  sapper (macOS)
//
//  Created by Ivan Markov on 02.03.2022.
//

import SwiftUI

struct macOSView: View {
    
    @ObservedObject var game = Game()
    
    var body: some View {
        HStack {
            Button(action: {
                
            }, label: {
                Text("Hi")
            })
            CellFieldView(field: game.field)
        }
    }
}

struct macOSView_Previews: PreviewProvider {
    static var previews: some View {
        macOSView()
    }
}

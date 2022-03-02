//
//  iOSView.swift
//  sapper (iOS)
//
//  Created by Ivan Markov on 02.03.2022.
//

import SwiftUI

struct iOSView: View {
    
    @ObservedObject var game = Game()
    
    var body: some View {
        TabView {
            CellFieldView(field: game.field)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(NSLocalizedString("Home", comment: ""))
                }
        }
    }
}

struct iOSView_Previews: PreviewProvider {
    static var previews: some View {
        iOSView()
    }
}

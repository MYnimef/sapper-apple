//
//  ContentView.swift
//  sapper
//
//  Created by Ivan Markov on 02.03.2022.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
#if os(iOS)
        iOSView()
#elseif os(macOS)
        macOSView()
#endif
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

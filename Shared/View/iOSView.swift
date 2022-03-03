//
//  iOSView.swift
//  sapper (iOS)
//
//  Created by Ivan Markov on 02.03.2022.
//

import SwiftUI


struct iOSView: View {
    
    @ObservedObject var game = Game()
    
    init() {
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        TabView {
            GameView(game: game)
                .tabItem {
                    Image(systemName: "play.fill")
                    Text(NSLocalizedString("Play", comment: ""))
                }
            OptionsView(game: game)
                .tabItem {
                    Image(systemName: "gear.circle.fill")
                    Text(NSLocalizedString("Options", comment: ""))
                }
            AchievementsView(game: game)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text(NSLocalizedString("Achievements", comment: ""))
                }
        }
    }
}


fileprivate struct GameView: View {
    
    @ObservedObject var game: Game
    
    var body: some View {
        VStack {
            Spacer(minLength: 20)
            HStack {
                Spacer(minLength: 20)
                CellFieldView(field: game.field)
                Spacer(minLength: 20)
            }
            Spacer(minLength: 20)
        }
    }
}


fileprivate struct OptionsView: View {
    
    @ObservedObject var game: Game
    
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 20)
                Button {
                    game.newGame()
                } label: {
                    Text("New game")
                }
                Spacer(minLength: 20)
            }
        }
    }
}


fileprivate struct AchievementsView: View {
    
    @ObservedObject var game: Game
    
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 20)
                Spacer(minLength: 20)
            }
        }
    }
}


struct iOSView_Previews: PreviewProvider {
    static var previews: some View {
        iOSView()
    }
}

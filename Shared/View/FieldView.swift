//
//  FieldView.swift
//  sapper
//
//  Created by Ivan Markov on 28.02.2022.
//

import SwiftUI


struct CellFieldView: View {
    
    var field: [CellLine]
    
    var body: some View {
        //VStack {
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                ForEach(field) { i in
                    CellLineView(line: i.getLine())
                }
            }
        //}
    }
}


struct CellLineView: View {
    
    let line: [Cell]
    
    init(line: [Cell]) {
        self.line = line
    }
    
    var body: some View {
        HStack {
            ForEach (line) { i in
                CellView(cell: i)
            }
        }
    }
}


struct CellView: View {
    
    @ObservedObject var cell: Cell
    
    var body: some View {
        Button(action: {
            cell.open()
        }, label: {
            switch cell.getState() {
            case .closed:
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            case .opened:
                if cell is NumberCell {
                    NumberCellView(number: cell.getContent())
                } else if cell is MineCell {
                    MineCellView(mine: cell.getContent())
                } else {
                    OpenedCellView()
                }
            case .marked:
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            }
        })
            .buttonStyle(.borderless)
    }
}


struct OpenedCellView: View {
    
    var body: some View {
        Rectangle()
            .fill(.gray)
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
    }
}


struct NumberCellView: View {
    
    let number: String
    
    var body: some View {
        ZStack {
            OpenedCellView()
            Text(number)
                .font(.system(size: 40))
                .foregroundColor(numberColor(number: number))
        }
    }
}


struct MineCellView: View {
    
    let mine: String
    
    var body: some View {
        ZStack {
            OpenedCellView()
            Text(mine)
                .font(.system(size: 40))
                .foregroundColor(.red)
        }
    }
}


func numberColor(number: String) -> Color {
    
    switch number {
    case "1":
        return .blue
    case "2":
        return .green
    case "3":
        return .yellow
    case "4":
        return .orange
    case "5":
        return .brown
    case "6":
        return .purple
    case "7":
        return .pink
    default:
        return .black
    }
}

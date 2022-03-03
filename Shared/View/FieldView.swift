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
#if os(iOS)
                addActions(
                    view: AnyView(
                        Button(action: {
                        }, label: {
                            CellView(cell: i)
                        })
                    ),
                    actionClick: i.open,
                    actionLong: i.mark
                )
#elseif os(macOS)
                addActions(
                    view: AnyView(
                        CellView(cell: i)
                    ),
                    actionClick: i.open,
                    actionLong: i.mark
                )
#endif
            }
        }
    }
}


func addActions(view: AnyView, actionClick: @escaping () -> (), actionLong: @escaping () -> ()) -> AnyView {
    return AnyView(
        view
            .simultaneousGesture(
                LongPressGesture()
                    .onEnded { _ in
                        actionLong()
                    }
            )
            .highPriorityGesture(
                TapGesture()
                    .onEnded { _ in
                        actionClick()
                    }
            )
    )
}


struct CellView: View {
    
    @ObservedObject var cell: Cell
    
    var body: some View {
        switch cell.getState() {
        case .closed:
            ShapeCellView(color: .blue)
        case .opened:
            if cell is NumberCell {
                NumberCellView(number: (cell as! NumberCell).getNumber())
            } else if cell is MineCell {
                MineCellView()
            } else {
                ShapeCellView(color: .gray)
            }
        case .marked:
            ShapeCellView(color: .red)
        }
    }
}


struct ShapeCellView: View {
    
    let color: Color
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
    }
}


struct NumberCellView: View {
    
    let number: String
    
    var body: some View {
        ZStack {
            ShapeCellView(color: .gray)
            Text(number)
                .font(.system(size: 40))
                .foregroundColor(numberColor(number: number))
        }
    }
}


struct MineCellView: View {
    
    var body: some View {
        ZStack {
            ShapeCellView(color: .red)
            Text("💣")
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

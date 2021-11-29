//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Khoa Tran on 28/11/2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        AspectVGrid(items: viewModel.cards, aspectRatio: 2/3) { card in
            if card.isMatched {
                Rectangle().opacity(0)
            } else {
                CardView(card)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .foregroundColor(.red)
        .padding(.horizontal)
    }
}

struct CardView: View {
    private let card: EmojiMemoryGame.Card
    
    init(_ givenCard: EmojiMemoryGame.Card) {
        card = givenCard
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp || card.isMatched {
                    shape.fill()
                        .foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 20))
                        .padding(5)
                        .opacity(0.5)
                    Text(card.content)
                        .font(font(in: geometry.size))
                } else {
                    shape.fill()
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(viewModel: game)
        //        ContentView().preferredColorScheme(.dark)
    }
}

//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Khoa Tran on 28/11/2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    restartBody
                    Spacer()
                    shuffleBody
                }
                .padding(.horizontal)
            }
            deckBody
        }
        .padding()
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = viewModel.cards.firstIndex(where: {$0.id == card.id}) {
            delay = Double(index) * (CardConstants.totalDuration / Double(viewModel.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(viewModel.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: viewModel.cards, aspectRatio: CardConstants.aspectRatio) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            viewModel.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(viewModel.cards.filter(isUndealt)) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
            .frame(width: CardConstants.undealWidth, height: CardConstants.undealHeight)
            .foregroundColor(CardConstants.color)
            .onTapGesture {
                // "deal" cards
                for card in viewModel.cards {
                    withAnimation(dealAnimation(for: card)) {
                        deal(card)
                    }
                }
            }
        }
    }
    
    var shuffleBody: some View {
        Button("Suffle") {
            withAnimation {
                viewModel.shuffle()
            }
        }
    }
    
    var restartBody: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                viewModel.restart()
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDuration: Double = 2
        static let undealWidth: CGFloat = 60
        static let undealHeight: CGFloat = undealWidth / aspectRatio
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

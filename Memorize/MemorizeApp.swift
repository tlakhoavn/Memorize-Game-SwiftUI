//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Khoa Tran on 28/11/2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}

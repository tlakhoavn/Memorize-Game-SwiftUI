//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Khoa Tran on 28/11/2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}

//
//  QuickTranslatorApp.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import SwiftUI
import SwiftData

@main
struct QuickTranslatorApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isPinned: Bool = false

    var body: some Scene {
            Settings {} // opsiyonel        
        
//        MenuBarExtra("QuickTranslator", systemImage: "text.book.closed") {
//            ContentView(viewModel: ContentViewModel())
//                .overlay(alignment: .topTrailing) {
//                    HStack(spacing: 8) {
//                        Button {
//                            isPinned.toggle()
//                        } label: {
//                            Image(systemName: isPinned ? "pin.fill" : "pin")
//                        }
//                        .buttonStyle(.plain)
//                        
//                        Button(
//                            "Quit",
//                            systemImage: "xmark.circle.fill"
//                        ) {
//                            NSApp.terminate(nil)
//                        }
//                        .labelStyle(.iconOnly)
//                        .buttonStyle(.plain)
//                    }
//                    .padding(10)
//                }
//                .frame(width: 400, height: 400)
//        }
//        .menuBarExtraStyle(.window)
//        .onChange(of: isPinned) { newValue in
//            // Eğer pinlenmemişse ve kullanıcı başka yere tıklarsa kapanabilir
//            // Menü Bar Extra davranışı burada kontrol edilebilir
//            // SwiftUI'de tam otomatik kapanmayı engellemek için window delegate gerekebilir
//        }
    }
}

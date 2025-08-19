//
//  ContentView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 18.08.2025.
//

import SwiftUI
import Translation

struct ContentView: View {
    @State private var textInput: String = ""
    @State private var showTranslation: Bool = false
    @State private var configuration: TranslationSession.Configuration?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Add your text below:")
                .foregroundStyle(.secondary)
                .padding(6)
            PaddedTextEditor(text: $textInput)
                .font(.headline)
                .scrollContentBackground(.hidden)
                .background(.placeholder)
                .clipShape(.buttonBorder)
                .padding(4)
                .onAppear {
                    let pasteBoardText = NSPasteboard.general.string(forType: .string) ?? ""
                    textInput = pasteBoardText
                }
            
            Button(
                "Show Translate",
                systemImage: "square.on.square"
            ) {
                if configuration == nil {
                    configuration = .init(source: .init(identifier: "en"), target: .init(identifier: "tr"))
                } else {
                    configuration?.invalidate()
                }
            }
            .buttonStyle(.plain)
            .foregroundStyle(.blue)
            .bold()
        }
        .padding(8)
        .translationTask(configuration) { session in
            do {
                let response = try await session.translate(textInput)
                textInput = response.targetText
            } catch {  }
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 450, height: 250)
}

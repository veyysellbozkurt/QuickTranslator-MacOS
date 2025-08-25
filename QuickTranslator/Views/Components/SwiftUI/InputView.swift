//
//  InputView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 22.08.2025.
//

import SwiftUI

struct InputView: View {
    
    @Binding var text: String
    @Binding var language: Language
    var onEnterKeyPress: (() -> Void)? = nil
    
    @State private var showLanguagePicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {            
            Button {
                showLanguagePicker.toggle()
            } label: {
                HStack {
                    Text(language.rawValue.capitalized)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
                .background(Color.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showLanguagePicker) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Language.allCases, id: \.self) { lang in
                            Button {
                                language = lang
                                showLanguagePicker = false
                            } label: {
                                Text(lang.rawValue.capitalized)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            
                            Divider()
                        }
                    }
                }
                .frame(width: 200, height: 250)
            }
                        
            PaddedTextViewRepresentable(text: $text, onEnterKeyPress: onEnterKeyPress)
                .scrollContentBackground(.hidden)
                .background(Color(nsColor: .windowBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

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
    var placeholder: String?
    var onEnterKeyPress: (() -> Void)? = nil
    @State var showToast = false
    
    @State private var showLanguagePicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button {
                showLanguagePicker.toggle()
            } label: {
                HStack {
                    Text(language.title)
                        .font(.body)
                    Spacer()
                    Image(systemName: SFIcons.chevronDown)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
                .frame(height: 28)
                .background(Color.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.horizontal, 2)
            .buttonStyle(BounceButtonStyle())
            .popover(isPresented: $showLanguagePicker) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Language.allCases, id: \.self) { lang in
                            Button {
                                language = lang
                                showLanguagePicker = false
                            } label: {
                                Text(lang.title)
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
            
            PaddedTextViewRepresentable(
                text: $text,
                onEnterKeyPress: onEnterKeyPress,
                placeholder: placeholder ?? ""
            )
            .scrollContentBackground(.hidden)
            .background(.clear)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.top, 0)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(text, forType: .string)
                    pasteboard.setString(PasteboardMarker.value, forType: PasteboardMarker.type)
                    showToast.toggle()
                } label: {
                    Image(systemName: SFIcons.copy)
                        .resizable()
                        .frame(width: 16, height: 18)
                        .padding(8)
                        .foregroundStyle(text.isEmpty ? Color.secondary : Color.app)
                }
                .buttonStyle(BounceButtonStyle())
                .padding(6)
                .disabled(text.isEmpty)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .toast(isPresented: $showToast, message: "Copied to Clipboard ✅")
    }
}





struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let duration: TimeInterval
    
    init(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 1.0) {
        self._isPresented = isPresented
        self.message = message
        self.duration = duration
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                VStack {
                    Spacer()
                    Text(message)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 40)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation {
                                    isPresented = false
                                }
                            }
                        }
                }
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 1.0) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message, duration: duration))
    }
}

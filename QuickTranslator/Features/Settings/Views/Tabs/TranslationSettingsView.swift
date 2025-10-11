//
//  TranslationSettingsView.swift
//  QuickTranslator
//
//  Created by Veysel Bozkurt on 6.10.2025.
//

import SwiftUI
import AppKit

// MARK: - App-Specific Type Aliases (Varsayılan olarak String kullanıldı)

// Bu, uygulamanızda zaten var olan TranslationServiceType enum'una karşılık gelir.
typealias ServiceType = String // TranslationServiceType (örneğin: "online", "offline")

// MARK: - Main View

struct TranslationSettingsView: View {
    
    // Uygulamanızdaki ServiceType'ı (String) kullanıyoruz
    @AppStorage("selectedTranslationServiceType")
    private var selectedServiceType: ServiceType = "online" // Varsayılan: "online"
    
    @State private var showSystemSteps = false
    private let viewWidth: CGFloat = 650
    
    var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                
                // Başlık
                VStack(alignment: .leading, spacing: 4) {
                    Text("Çeviri Motoru Ayarları").font(.title2.bold())
                    Text("Hangi çeviri motorunun kullanılacağını seçin.")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                
                // Seçim kartları
                HStack(spacing: 20) {
                    EngineCard(
                        title: "Apple Translate",
                        subtitle: "Tamamen çevrimdışı çalışır.\nSınırlı dil desteği ve kalitesi.",
                        image: Image(systemName: "applelogo"),
                        isSelected: selectedServiceType == "offline"
                    ) {
                        withAnimation(.easeInOut) { selectedServiceType = "offline" }
                    }
                    
                    EngineCard(
                        title: "SwiftyTranslate",
                        subtitle: "Yüksek kaliteli çevrimiçi çeviriler.\nİnternet bağlantısı gereklidir.",
                        image: Image(systemName: "globe"),
                        isSelected: selectedServiceType == "online"
                    ) {
                        withAnimation(.easeInOut) { selectedServiceType = "online" }
                    }
                }
                
                Divider()
                
                // Bilgilendirme alanı (Dinamik)
                if selectedServiceType == "offline" {
                    OfflineInfo(showSystemSteps: $showSystemSteps)
                        .transition(.slide)
                } else {
                    InfoBox(
                        title: "Sınırsız Dil Desteği",
                        message: "SwiftyTranslate, çevrimiçi API'ları kullanarak neredeyse tüm ana dünya dillerini destekler."
                    )
                    .transition(.opacity)
                }
                
                Divider()
                
            }
            .padding(30)
            .frame(width: viewWidth, alignment: .leading)                    
    }
}

// MARK: - 1. Engine Card Component

struct EngineCard: View {
    let title: String
    let subtitle: String
    let image: Image
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.headline.bold())
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(20)
//            .frame(maxWidth: .infinity, minHeight: 60, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor.opacity(0.12) : Color(.windowBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.4), lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 2. Offline Info Component

struct OfflineInfo: View {
    @Binding var showSystemSteps: Bool
    
    private let systemURL = URL(string: "x-apple.systempreferences:com.apple.Localization-Settings.Extension")!
    
    // Gerçek dil sayısının uygulamanızdaki kaynaktan geleceği varsayılmıştır.
    private let supportedLanguageCount = 21
    
    private let systemSteps = [
        "**Genel** sekmesine gidin.",
        "**Dil ve Bölge**'yi açın.",
        "En alttaki **'Çeviri Dilleri...'** düğmesine tıklayın."
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            InfoBox(
                title: "Çevrimdışı Mod Aktif",
                message: "Çevrimdışı çeviri için dilleri indirmeniz gerekir. İndirme ve dil yönetimi macOS Sistem Ayarları üzerinden yapılır."
            )
            
            // Desteklenen Diller Bilgisi
            VStack(alignment: .leading, spacing: 10) {
                Text("Apple Translate Desteklenen Dil Sayısı: \(supportedLanguageCount)")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                // Gerçek diller burada listelenmeyecek, sadece sayı ve bilgi verilecek.
                Text("Bu dillerin tam listesi ve indirme durumu macOS **Çeviri Dilleri** penceresinde görülebilir.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Yönlendirme ve Talimatlar
            VStack(alignment: .leading, spacing: 12) {
                Text("Dilleri indirmek için Sistem Ayarlarına gitmelisiniz.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    if showSystemSteps {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Lütfen şimdi açılan **Sistem Ayarları** penceresinde bu adımları takip edin:")
                                .font(.subheadline).bold()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(systemSteps.indices, id: \.self) { index in
                                    HStack(spacing: 8) {
                                        Image(systemName: "\(index + 1).circle.fill").foregroundColor(.accentColor)
                                        Text(.init(systemSteps[index]))
                                    }
                                }
                            }
                        }
                        .padding(12)
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(8)
                        
                    } else {
                        // Güvenilir Buton Kullanımı
                        Button {
                            if NSWorkspace.shared.open(systemURL) {
                                showSystemSteps = true
                            }
                        } label: {
                            Label("Sistem Ayarlarını Aç", systemImage: "gearshape.fill")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    Spacer()
                }
            }
        }
    }
}

// MARK: - 3. Info Box Component

struct InfoBox: View {
    let title: String
    let message: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.headline.bold())
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.08))
        )
    }
}

// MARK: - Preview

#Preview {
    TranslationSettingsView()
        .padding()
}

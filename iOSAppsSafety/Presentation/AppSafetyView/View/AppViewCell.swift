//
//  AppViewCell.swift
//  iOSAppsSafety
//
//  Created by Harish Garg on 2025-02-10.
//

import SwiftUI


struct AppViewCell: View {
    
    // MARK: - Properties
    @State var appURL: Urls?
    @State var showAlert = false

    
    // MARK: - Body
    var body: some View {
        
        Button(action: {
            showAlert = true
            }) {
                HStack(spacing: 10.0, content: {
                    
                    Circle()
                        .fill(getRiskColor(for: appURL?.url_status))
                        .frame(width: 16, height: 16)
                        .padding(.leading, 15)
                    
                    VStack(alignment: .leading) {
                        Text((appURL?.threat ?? "").capitalized)
                            .font(Fonts.Medium.font(16))
                            .foregroundColor(.titleTextColor)
                            .lineLimit(1)
                        
                        Spacer(minLength: 5)
                        
                        Text((appURL?.urlhaus_reference ?? "").capitalized)
                            .font(Fonts.Regular.font(14))
                            .foregroundColor(.subTitleTextColor)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Image.rightArrow
                        .foregroundColor(.titleTextColor)
                        .padding(.trailing, 15)
                    
                })
                .padding(.vertical, 15)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("confirm".localized),
                          message: Text("openURLAlert".localized),
                          primaryButton: .destructive(Text("Open".localized)) {
                        guard let url = appURL?.urlhaus_reference else {return}
                        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                    },secondaryButton: .cancel())
                }
            }
    }
    
    
    
    // MARK: - Class Functions

    private func getRiskColor(for risk: String?) -> Color {
        switch risk {
        case "online": return .redColor
        case "offline": return .yellowColor
        case .some:
            return .redColor
        case .none:
            return .yellowColor
        }
    }
    
}

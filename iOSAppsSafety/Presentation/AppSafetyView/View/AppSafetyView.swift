//
//  ContentView.swift
//  iOSAppsSafety
//
//  Created by Harish Garg on 2025-02-10.
//

import SwiftUI

struct AppSafetyView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = AppSafetyViewModel()
    
    
    //MARK: View
    var body: some View {
        NavigationStack {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack{
                    
                    
                    //Top Red background Label
                    topWarningDetailView
                    
                    //Protection Toast Message View
                    protectionToastMessageView
                    
                    
                    //This switch statement will run when ever Apps Listing API will be execute
                    switch viewModel.state {
                    case .idle:
                        Color.clear
                            .onAppear {
                                //viewModel.loadMore()
                            }
                    case .isLoading:
                        
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(maxWidth: .infinity)
                        
                    case .loadedAllApps:
                       
                        //Apps Listing View
                        appsListView
                        
                    case .error(let message):
                        Text(message)
                            .foregroundColor(.pink)
                    }
                    
                    
                    Spacer()
                }
            }
            .navigationTitle("title".localized)
            .background(
                Color
                    .mainBackgroundColor
                    .ignoresSafeArea()
            )
        }
    }
    
    // MARK: - Views
    
    private var topWarningDetailView: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Image.exclamationmark
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.darkRedColor.opacity(0.8))
                    .clipShape(Circle())
                    .shadow(radius: 8)
                
                Spacer()
            }
            
            Text("highRisk".localized)
                .font(Fonts.Medium.font(28))
                .foregroundColor(.white)
            
            Text("\("lastScan".localized) - 23.03.22 14:32")
                .font(Fonts.Medium.font(16))
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            Button {
                //Start scan button action
            } label: {
                Text("scanButton".localized)
                    .font(Fonts.Medium.font(14))
                    .foregroundColor(.white)
                    .frame(width: 160, height: 45)
                    .background(Color.darkRedColor)
                    .cornerRadius(16)
                    .shadow(radius: 5)
            }
        }
        .padding()
        .background(Color.redColor)
        .cornerRadius(12)
        .padding()
        .shadow(radius: 5)
        
    }
    
    
    private var protectionToastMessageView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("appProtection".localized)
                .padding(9)
                .font(Fonts.Regular.font(12))
                .foregroundColor(.titleTextColor)
                .background(Color.toastBackgroundColor)
                .cornerRadius(16)
                .frame(maxWidth: .infinity)
                .shadow(radius: 2)
        }
    }
    
    private var appsListView: some View {
        LazyVStack {
            ForEach(viewModel.appsList, id:\.id) { appURL in
                AppViewCell(appURL: appURL)
            }
        }
        .background(
            Color
                .listBackgroundColor
                .ignoresSafeArea()
        )
        .cornerRadius(12)
        .padding()
        
    }
    
}

struct AppSafetyView_Previews: PreviewProvider {
    static var previews: some View {
        AppSafetyView()
    }
}

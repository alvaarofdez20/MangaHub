//
//  RootView.swift
//  MangaHub
//

import SwiftUI

struct RootView: View {
    
    var body: some View {
        MainTabView()
    }
}

#Preview {
    RootView()
        .environment(
            AppEnvironment.preview()
        )
        .environment(
            AppRouter(stage: .main)
        )
}

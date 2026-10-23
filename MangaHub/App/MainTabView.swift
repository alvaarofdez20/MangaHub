//
//  MainTabView.swift
//  MangaHub
//

import SwiftUI

struct MainTabView: View {
    
    // MARK: - Environment
    @Environment(AppRouter.self) private var router
    
    // MARK: - Body
    var body: some View {
        
        @Bindable var router = router
        
        TabView(
            selection: $router.selectedTab
        ) {
            
            NavigationStack(
                path: $router.homePath
            ) {
                HomeScreen()
                    .navigationDestination(
                        for: HomeRoute.self
                    ) { route in
                        switch route {
                            
                        case .detail(let manga):
                            
                            MangaDetailScreen(
                                manga: manga
                            )
                        }
                    }
            }
            .tabItem{
                Label("Explorar", systemImage: "magnifyingglass")
            }
            .tag(AppTab.home)
            
            NavigationStack(
                path: $router.collectionPath
            ) {
                CollectionScreen()
                    .navigationDestination(
                        for: CollectionRoute.self
                    ) { route in
                        
                        switch route {
                            
                        case .detail(let mangaId):
                            
                            CollectedMangaDetailScreen(
                                mangaId: mangaId
                            )
                        }
                    }
            }
            .tabItem{
                Label(
                    "Colección",
                    systemImage: "books.vertical"
                )
            }
            .tag(
                AppTab.collection
            )
        }
    }
}

#Preview {
    MainTabView()
        .environment(
            AppEnvironment.preview()
        )
}

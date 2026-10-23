//
//  ScoreView.swift
//  MangaHub
//

import SwiftUI

struct ScoreView: View {
    
    var score: Double?
    
    var body: some View {
        
        HStack(spacing: 6) {
            
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
            
            Text(formattedScore)
                .font(.subheadline)
                .fontWeight(.medium)
            
        }
    }
    
    private var formattedScore: String {
        
        guard let score else { return "-" }
        return String(format: "%.2f", score)
    }
}

#Preview {
    
    VStack(spacing: 20) {
        ScoreView(score: 9.15)
        ScoreView(score: nil)
    }
}

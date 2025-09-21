//
//  FavoritesAndRecentlyPlayedViews.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 8/8/25.
//

import SwiftUI
import AppProgressModel
import AppMeditationAttention

// MARK: - FavoritesView
struct FavoritesView: View {
    @EnvironmentObject var progressModel: AppProgressModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedMeditation: Meditation?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.defaultAppWhite)
                            .font(.system(size: 18, weight: .medium))
                    }
                    
                    Spacer()
                    
                    Text("Favorites")
                        .font(.title2.bold())
                        .foregroundColor(.defaultAppWhite)
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.clear)
                            .font(.system(size: 18, weight: .medium))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                if progressModel.meditationManager.favoriteMeditations.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                        
                        Text("No Favorites Yet")
                            .font(.title2.bold())
                            .foregroundColor(.defaultAppWhite)
                        
                        Text("Add meditations to your favorites to see them here")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Favorites list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(progressModel.meditationManager.favoriteMeditations) { meditation in
                                DownloadedMeditationRow(
                                    meditation: meditation,
                                    onDelete: {
                                        progressModel.meditationManager.removeFromFavorites(meditation)
                                    },
                                    onTap: {
                                        selectedMeditation = meditation
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                }
            }
            .background(Color.defaultAppDark.ignoresSafeArea())
            .navigationBarHidden(true)
            .navigationDestination(item: $selectedMeditation) { meditation in
                MeditationDetailView(meditation: meditation)
                    .environmentObject(progressModel)
            }
        }
    }
}

// MARK: - RecentlyPlayedView
struct RecentlyPlayedView: View {
    @EnvironmentObject var progressModel: AppProgressModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedMeditation: Meditation?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.defaultAppWhite)
                            .font(.system(size: 18, weight: .medium))
                    }
                    
                    Spacer()
                    
                    Text("Recently Played")
                        .font(.title2.bold())
                        .foregroundColor(.defaultAppWhite)
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.clear)
                            .font(.system(size: 18, weight: .medium))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                if progressModel.meditationManager.recentlyPlayedMeditations.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "clock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                        
                        Text("No Recent Activity")
                            .font(.title2.bold())
                            .foregroundColor(.defaultAppWhite)
                        
                        Text("Play some meditations to see them here")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Recently played list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(progressModel.meditationManager.recentlyPlayedMeditations) { meditation in
                                DownloadedMeditationRow(
                                    meditation: meditation,
                                    onDelete: {
                                        // Remove from recently played
                                        progressModel.meditationManager.recentlyPlayedMeditations.removeAll { $0.id == meditation.id }
                                    },
                                    onTap: {
                                        selectedMeditation = meditation
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                }
            }
            .background(Color.defaultAppDark.ignoresSafeArea())
            .navigationBarHidden(true)
            .navigationDestination(item: $selectedMeditation) { meditation in
                MeditationDetailView(meditation: meditation)
                    .environmentObject(progressModel)
            }
        }
    }
}


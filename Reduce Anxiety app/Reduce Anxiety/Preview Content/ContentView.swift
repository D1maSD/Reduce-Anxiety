//
//  ContentView.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 3/26/25.
//

import SwiftUI
import AppMainScreen
import AppTabBar
import AppChatView
import AppOnboarding
import AppMeditationAttention
import AppProgressModel
//import AppNotePad

struct ContentView: View {
    @State private var selectedTab: Tabs = .plus
    @State private var isInChatDetail: Bool = false
    @StateObject var progressModel = AppProgressModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            viewForSelectedTab()

            if !isInChatDetail {
                TabBar(activeTab: selectedTab) { tab in
                    selectedTab = tab
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder
    private func viewForSelectedTab() -> some View {
        switch selectedTab {
        case .home:
            HomeView()
                .environmentObject(progressModel)
        case .check:
            MeditationsView()
                .environmentObject(progressModel)
        case .plus:
            TasksView()
                .environmentObject(progressModel)
        case .chat:
            ChatsView($isInChatDetail)
        case .profile:
            ProfileView()
                .environmentObject(progressModel)
        }
    }
}

#Preview {
    ContentView()
}

struct MyView {
    private let _counter = State<Int>(initialValue: 0)
    var counter: Int {
        get { _counter.wrappedValue }
        set { _counter.wrappedValue = newValue }
    }
}

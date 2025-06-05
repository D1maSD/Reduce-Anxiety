//
//  ChatDetailView 2.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/27/25.
//

import SwiftUI
//import AppChatView

// MARK: - Tab Enum
public enum Tabs {
    case home
    case check
    case plus
    case chat
    case profile
}

// MARK: - Custom TabBar
public struct TabBar: View {
    var activeTab: Tabs
    var onTabSelected: (Tabs) -> Void
    public init(activeTab: Tabs, onTabSelected: (@escaping (Tabs) -> Void)) {
        self.activeTab = activeTab
        self.onTabSelected = onTabSelected
    }
    public var body: some View {
        HStack {
            Spacer()
            Button(action: { onTabSelected(.home) }) {
                Image(systemName: "house")
                    .foregroundColor(activeTab == .home ? .yellow : .black)
            }
            Spacer()
            Button(action: { onTabSelected(.check) }) {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(activeTab == .check ? .yellow : .black)
            }
            Spacer()
            Button(action: { onTabSelected(.plus) }) {
                ZStack {
                    Circle()
                        .foregroundColor(.yellow)
                        .frame(width: 50, height: 50)
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }
            }
            Spacer()
            Button(action: { onTabSelected(.chat) }) {
                Image(systemName: "message.fill")
                    .foregroundColor(activeTab == .chat ? .yellow : .black)
            }
            Spacer()
            Button(action: { onTabSelected(.profile) }) {
                Image(systemName: "person")
                    .foregroundColor(activeTab == .profile ? .yellow : .black)
            }
            Spacer()
        }
        .padding()
        .background(Color.white.shadow(radius: 2))
    }
}
// MARK: - Preview
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatefulPreviewWrapper(false) { binding in
//            ChatsView(binding)
//        }
//    }
//}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

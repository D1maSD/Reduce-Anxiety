//
//  MeditationAttentionScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/27/25.
//
import SwiftUI

// MARK: - Chat Model
struct Chat: Identifiable {
    let id = UUID()
    let userName: String
    let lastMessage: String
    let userImageName: String
}

public struct ChatsView: View {
    @State private var selectedChat: Chat? = nil
    @Binding var isInChatDetail: Bool

    private let chats = [
        Chat(userName: "Philip", lastMessage: "Thank you! That was very helpful!", userImageName: "person.circle"),
        Chat(userName: "Vera Lisyk", lastMessage: "I’m here if you want to talk.", userImageName: "person.circle")
    ]

    public init(_ isInChatDetail: Binding<Bool>) {
        self._isInChatDetail = isInChatDetail
    }

    public var body: some View {
        NavigationStack {
            List {
                // Верхний текст в секции с белым фоном
                Section {
                    Text("You can also make answer to our AI Psychologist, learned by real psychologist, or answer for psychologist on real chat")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.vertical, 8)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(Color.defaultAppDark)
                }
                .listRowBackground(Color.defaultAppDark) // фон всей строки — белый
                .background(Color.defaultAppDark)        // фон секции — белый

                // Чаты
                Section {
                    ForEach(chats) { chat in
                        Button(action: {
                            selectedChat = chat
                            isInChatDetail = true
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: chat.userImageName)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .padding(.vertical, 8)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(chat.userName)
                                        .font(.headline)
                                        .foregroundColor(chat.userName == "Philip" ? .white : .primary)
                                    Text(chat.lastMessage)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.defaultAppGray)
                            .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.defaultAppDark.ignoresSafeArea())
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar) // 👈 блюр фона навбара
            .toolbarBackground(.visible, for: .navigationBar)            // 👈 делает его видимым
            .background(
                NavigationLink(
                    destination: ChatDetailView(chat: selectedChat, isInChatDetail: $isInChatDetail),
                    isActive: Binding(
                        get: { selectedChat != nil },
                        set: {
                            if !$0 {
                                selectedChat = nil
                                isInChatDetail = false
                            }
                        }
                    ),
                    label: { EmptyView() }
                )
                .hidden()
            )
        }
    }
}
#Preview {
    StatefulPreviewWrapper(false) { binding in
        ChatsView(binding)
    }
}



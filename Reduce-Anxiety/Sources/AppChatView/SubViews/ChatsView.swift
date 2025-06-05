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
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                Text("You can also make answer to our AI Psychologist, learned by real psychologist, or answer for psychologist on real chat")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()

                List(chats) { chat in
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
                                Text(chat.lastMessage)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Chats")

                .background(
                               NavigationLink(
                                   destination: ChatDetailView(chat: selectedChat, isInChatDetail: $isInChatDetail),
                                   isActive: Binding(
                                       get: { selectedChat != nil },
                                       set: {
                                           if !$0 {
                                               selectedChat = nil
                                               isInChatDetail = false // 👈 возвращаем таббар обратно
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
}

#Preview {
    StatefulPreviewWrapper(false) { binding in
        ChatsView(binding)
    }
}



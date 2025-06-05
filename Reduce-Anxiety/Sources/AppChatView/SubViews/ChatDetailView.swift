//
//  ChatsView 2.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/27/25.
//

import SwiftUI


// MARK: - Chat Detail View
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isCurrentUser: Bool
}


struct ChatDetailView: View {
    let chat: Chat?
    @Binding var isInChatDetail: Bool
    @State private var inputText: String = ""
    @State private var messages: [Message] = [
        Message(text: "Really love your most recent photo!", isCurrentUser: false),
        Message(text: "A fast 50mm like f/1.8 would help with the bokeh.", isCurrentUser: true),
        Message(text: "Thank you! That was very helpful!", isCurrentUser: false)
    ]
    
    @State private var isSubscriptionByed: Bool = false // заменишь на реальное значение
    private let backgroundColor = Color(hex: "#FAFAF0")

    var isLockedChat: Bool {
        chat?.userName == "Vera Lisyk" && !isSubscriptionByed
    }

    var body: some View {
        VStack {
            ScrollView {
                if isLockedChat {
                    VStack {
                        Text("Ask a real psychologist about your problem just for 8.99$ per one 10-min session, to buy this opportunity tap on button below")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .padding()

                        Button("Try") {
                            // handle subscription
                        }
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .frame(height: UIScreen.main.bounds.height / 3)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                } else {
                    VStack(spacing: 16) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isCurrentUser { Spacer() }

                                Text(message.text)
                                    .padding()
                                    .background(message.isCurrentUser ? Color.yellow : Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(12)
                                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: message.isCurrentUser ? .trailing : .leading)

                                if !message.isCurrentUser { Spacer() }
                            }
                        }
                    }
                    .padding()
                }
            }

            Divider()

            HStack {
                ZStack(alignment: .leading) {
                    if inputText.isEmpty {
                        Text(isLockedChat ? "try this after buy subscription" : "Message")
                            .foregroundColor(.gray)
                            .padding(.leading, 20)
                    }

                    TextField("", text: $inputText)
                        .disabled(isLockedChat)
                        .padding(12)
                        .foregroundColor(.gray)
                        .background(Color.white)
                        .cornerRadius(10)
                }

                if !inputText.isEmpty && !isLockedChat {
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    .transition(.scale)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(backgroundColor.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(chat?.userName ?? "")
                    .foregroundColor(.black) // <-- Явно чёрный цвет
                    .font(.headline)
            }
        }

        .onDisappear { isInChatDetail = false }
        .toolbarBackground(backgroundColor, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .onAppear {
            
        }
        .onTapGesture {
            hideKeyboard()
        }
    }

    private func sendMessage() {
        let newMessage = Message(text: inputText, isCurrentUser: true)
        messages.append(newMessage)
        inputText = ""
    }

    
}

#Preview {
    StatefulPreviewWrapper(true) { binding in
        ChatDetailView(
            chat: Chat(userName: "Philip", lastMessage: "Hello", userImageName: "person.circle"),
            isInChatDetail: binding
        )
    }
}
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: .whitespacesAndNewlines))
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

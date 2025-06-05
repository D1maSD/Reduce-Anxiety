//
//  ForgotPasswordView.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/23/25.
//

import SwiftUI

// 1. Forgot Password
struct ForgotPasswordView: View {
    @State private var email: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
                Spacer()
                Text("Password recovery")
                    .foregroundColor(.white)
                    .font(.subheadline)
                Spacer().frame(width: 24)
            }

            Text("Forgot password?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Don't worry! It happens. Please enter the email associated with your account.")
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)

            TextField("Email", text: $email)
                .padding()
                .background(Color.white.opacity(0.1))
                .foregroundColor(.white)
                .cornerRadius(8)

            Button(action: {}) {
                Text("Send a code")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    ForgotPasswordView()
}

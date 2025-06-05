//
//  SignInScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/8/25.
//

import SwiftUI

// MARK: - 1. SignInView
struct SignInView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                Button("Skip") {}
                    .foregroundColor(.white)
            }

            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                TextField("E-mail", text: $email)
                SecureField("Password", text: $password)
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.white)
            .textFieldStyle(PlainTextFieldStyle())

            HStack {
                Spacer()
                NavigationLink("Forgot password?", destination: ForgotPasswordView())
                    .foregroundColor(.white)
                    .font(.footnote)
            }

            Button(action: {}) {
                Text("Sign in")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }

            HStack {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                Text("or")
                    .foregroundColor(.gray)
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
            }

            HStack(spacing: 24) {
                ForEach(["f.circle", "g.circle", "applelogo"], id: \ .self) { name in
                    Image(systemName: name)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .clipShape(Circle())
                }
            }

            Spacer()

            HStack {
                Text("Don't you have an account?")
                    .foregroundColor(.gray)
                NavigationLink("Sign Up", destination: ContinueSignUp())
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}



#Preview {
    SignInView()
}

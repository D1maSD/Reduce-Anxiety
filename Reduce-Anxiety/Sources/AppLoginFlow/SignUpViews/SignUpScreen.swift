//
//  SignUpScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/8/25.
//

import SwiftUI

import SwiftUI

struct StartSignUp: View {
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                Button("Skip") {}
                    .foregroundColor(.white)
            }

            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                TextField("E-mail", text: $email)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)

                SecureField("Password", text: $password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }

            Button(action: {}) {
                Text("Sign up")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }

            Group {
                Text("By clicking the “sign up” button, you accept the terms of the ")
                    .foregroundColor(.gray)
                + Text("Privacy Policy")
                    .foregroundColor(.white)
            }
            .font(.footnote)

            Divider().background(Color.gray)

            HStack(spacing: 24) {
                ForEach(["facebook", "google", "apple"], id: \.self) { platform in
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.white.opacity(0.1))
                }
            }

            Spacer()

            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                Button("Sign In") {}
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    StartSignUp()
}

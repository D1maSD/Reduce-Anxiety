//
//  ResetPasswordView.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/23/25.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        VStack(spacing: 24) {
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

            VStack(alignment: .leading, spacing: 16) {
                Text("Reset password")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Please type something you'll remember")
                    .foregroundColor(.gray)
            }

            Group {
                SecureField("must contain at least 8 characters", text: $newPassword)
                SecureField("must contain at least 8 characters", text: $confirmPassword)
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .foregroundColor(.white)

            Button(action: {}) {
                Text("Reset password")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}


#Preview {
    ResetPasswordView()
}

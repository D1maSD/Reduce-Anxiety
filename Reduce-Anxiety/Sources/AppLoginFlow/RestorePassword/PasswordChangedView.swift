//
//  PasswordChangedView.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/23/25.
//

import SwiftUI

struct PasswordChangedView: View {
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

            Spacer()

            Color.gray
                .frame(width: 150, height: 150)
                .cornerRadius(20)
                .overlay(Text("Image").foregroundColor(.white))

            Text("Password changed")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Your password has been changed successfully")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)

            Button(action: {}) {
                Text("Back to login")
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
    PasswordChangedView()
}

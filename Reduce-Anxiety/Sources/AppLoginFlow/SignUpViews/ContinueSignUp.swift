//
//  ContinueSignUp.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/20/25.
//

import SwiftUI

struct ContinueSignUp: View {
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var city: String = ""

    var body: some View {
        VStack(spacing: 24) {
            Text("Sign up successfully!")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Tell us more about you")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                TextField("Your name", text: $name)
                TextField("Your phone number", text: $phone)
                TextField("Current City/pincode", text: $city)
            }
            .padding()
            .background(Color.black.opacity(0.2))
            .cornerRadius(8)
            .foregroundColor(.white)

            Spacer()

            Button(action: {}) {
                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}


#Preview {
    ContinueSignUp()
}

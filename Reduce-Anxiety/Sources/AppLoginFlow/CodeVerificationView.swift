//
//  CodeVerificationView.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/23/25.
//

import SwiftUI

struct CodeVerificationView: View {
    @State private var code: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusIndex: Int?
    @State private var timer: Int = 60
    
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
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Please check your email")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("We've sent a code to helloworld@gmail.com")
                    .foregroundColor(.gray)
            }

            HStack(spacing: 12) {
                ForEach(0..<4, id: \ .self) { index in
                    TextField("", text: $code[index])
                        .frame(width: 50, height: 50)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(code[index].isEmpty ? Color.gray.opacity(0.5) : Color.gray, lineWidth: 1.5)
                        )
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .focused($focusIndex, equals: index)
                        .onChange(of: code[index]) { _ in
                            if !code[index].isEmpty && index < 3 {
                                focusIndex = index + 1
                            }
                        }
                }
            }

            Button(action: {}) {
                Text("Check code")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }

            Text("Send code again 00:\(String(format: "%02d", timer))")
                .foregroundColor(.gray)

            Spacer()
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}


#Preview {
    CodeVerificationView()
}

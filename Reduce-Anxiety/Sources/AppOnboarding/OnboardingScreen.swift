//
//  OnboardingScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/8/25.
//

import SwiftUI

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.4)
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "face.smiling") // заменишь на логотип Sleepy
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.black)

                Text("SLEEPY")
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Button(action: {
                    
                }) {
                    Text("Continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.gray)
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                }
            }
           
            
        }
    }
}

struct OnboardingView: View {
    @State private var currentPage = 0

    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingPageView(
                imageName: "first",
                text: "Track your sleep patterns and improve your sleep habits with Sleepy",
                pageIndex: 0,
                currentPage: $currentPage
            )
            .tag(0)
            .foregroundColor(.black)
            OnboardingPageView(
                imageName: "second",
                text: "Get personalized tips and resources to help you sleep better with Sleepy",
                pageIndex: 1,
                currentPage: $currentPage
            )
            .tag(1)
            .foregroundColor(.black)

            OnboardingPageView(
                imageName: "third",
                text: "Say goodbye to insomnia with Sleepy’s interactive and engaging approach",
                pageIndex: 2,
                currentPage: $currentPage
            )
            .tag(2)
            .foregroundColor(.black)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let text: String
    let pageIndex: Int
    @Binding var currentPage: Int

    var body: some View {
        ZStack {
            Color.gray.opacity(0.4)
            VStack(spacing: 32) {
                Spacer()

                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width * 0.95,
                           height: UIScreen.main.bounds.height * 0.5)
                    .foregroundColor(.black)

                Text(text)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(index == currentPage ? Color.gray.opacity(0.4) : Color.gray.opacity(0.8))
                    }
                }

                Button(action: {
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        // Navigate to next flow
                    }
                }) {
                    Text("Continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(currentPage == 2 ? Color.white : Color.gray)
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                }

                Spacer()
            }
        }
    }
}

#Preview {
    Group {
//        SplashScreen()
        OnboardingView()
    }
}


//
//  MeditationAttentionScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/8/25.
//

import SwiftUI

// MARK: - Main View
struct Meditation: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
}

public struct MeditationsView: View {
    let meditations = [
        Meditation(title: "Love to body", subtitle: "Relax and unwind", imageName: "meditation1"),
        Meditation(title: "Best sides of yourself", subtitle: "Focus your mind", imageName: "meditation2"),
        Meditation(title: "Focus mind meditation", subtitle: "Focus your mind", imageName: "meditation2")
    ]
    public init() {}
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Meditations")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    ForEach(meditations) { meditation in
                        NavigationLink(destination: MeditationDetailView(meditation: meditation)) {
                            ZStack(alignment: .bottomLeading) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 240)
                                    .overlay(
                                        VStack(alignment: .leading, spacing: 8) {
                                            Spacer()
                                            Text(meditation.title)
                                                .font(.title2)
                                                .bold()
                                                .foregroundColor(.white)
                                            Text(meditation.subtitle)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                        }
                                        .padding()
                                    )
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .background(Color.white.ignoresSafeArea())
        }
//        .background(Color.green.ignoresSafeArea())
    }
}

struct MeditationDetailView: View {
    let meditation: Meditation
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(height: 400)
                    .clipShape(RoundedCorner(radius: 30, corners: [.bottomLeft, .bottomRight]))
                    .overlay(
                        VStack(alignment: .leading, spacing: 10) {
                            Spacer()
                            Text(meditation.title)
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                            Text(meditation.subtitle)
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        .padding(), alignment: .bottomLeading
                    )

                VStack(spacing: 0) {
//                    Spacer()
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(8) // ✅ меньше padding
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                            .padding(0) // ✅ внешний padding тоже чуть меньше
                    }
                    .padding(.trailing, 30)
                    .padding(.top, 60)
                }
                
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Benefits")
                        .font(.headline)
                    Text("Meditation helps reduce stress, improves concentration, and increases self-awareness. Practice daily for best results.")
                        .font(.body)

                    Text("How to practice")
                        .font(.headline)
                    Text("Find a quiet place, sit comfortably, and focus on your breath. Allow thoughts to pass without judgment.")
                        .font(.body)
                }
                .padding()
            }

            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true) // ✅ скрываем navigation bar
    }
}
// Utility shape for rounding specific corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}



// MARK: - Preview
struct MeditationsView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationsView()
    }
}

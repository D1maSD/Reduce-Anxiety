//
//  MeditationAttentionScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/8/25.
//

import SwiftUI
import AppProgressModel
// MARK: - Models

public struct Meditation: Identifiable {
    public let id = UUID()
    public let title: String
    public let subtitle: String
    public let imageName: String
    
    public init(title: String, subtitle: String, imageName: String) {
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
    }
}

enum GuideOption: String, CaseIterable, Identifiable {
    case jonathan = "Jonathan"
    case anna = "Anna"
    case francis = "Francis"
    case abby = "Abby"

    var id: String { rawValue }
}

enum DurationOption: String, CaseIterable, Identifiable {
    case six = "6"
    case eleven = "11"
    case fifteen = "15"

    var id: String { rawValue }

    var label: String {
        "\(rawValue) min + Audio"
    }

    var minutes: Int {
        Int(rawValue) ?? 0
    }
}

// MARK: - MeditationsView

public struct MeditationsView: View {
    let meditations = [
        Meditation(title: "Love to body", subtitle: "Relax and unwind", imageName: "meditation1"),
        Meditation(title: "Best sides of yourself", subtitle: "Focus your mind", imageName: "meditation2"),
        Meditation(title: "Santosha", subtitle: "Focus your mind", imageName: "meditation2"),
        Meditation(title: "Focus mind meditation", subtitle: "Focus your mind", imageName: "meditation2")
    ]
    @EnvironmentObject var progressModel: AppProgressModel
    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Color.clear.frame(height: 0)
                    ForEach(meditations) { meditation in
                        NavigationLink(destination:
                        MeditationDetailView(meditation: meditation)
                            .environmentObject(progressModel)
                        ) {
                            
                            ZStack(alignment: .bottomLeading) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.defaultAppGray)
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
                .padding(.top)
            }
            .navigationTitle("Meditations")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.gray.opacity(0.10), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color.defaultAppDark)
        }
    }
}

// MARK: - MeditationDetailView

struct MeditationDetailView: View {
    let meditation: Meditation
    @State private var showOptionsSheet = false
    @State private var showGuideSheet = false
    @State private var showMediaOptions = false
    @State private var showPlayer = false
    @State private var selectedGuide: GuideOption = .jonathan
    @State private var selectedDuration: DurationOption = .eleven
    @EnvironmentObject var progressModel: AppProgressModel
    var body: some View {
        ZStack {
            Color.defaultAppDark.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Button(action: { showOptionsSheet.toggle() }) {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                Spacer()

                Button(action: { showPlayer.toggle() }) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.black)
                        .padding(30)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity, alignment: .center)

                Text(meditation.title)
                    .font(.title2.bold())
                    .foregroundColor(.defaultAppWhite)
                    .padding(.horizontal)

                Text(meditation.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                HStack(spacing: 12) {
                    Button(action: { showGuideSheet.toggle() }) {
                        HStack {
                            Text("Guide")
                            Spacer()
                            Text(selectedGuide.rawValue)
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .background(Color.defaultAppGray)
                        .cornerRadius(12)
                        .foregroundColor(.defaultAppWhite)
                    }

                    Button(action: { showMediaOptions.toggle() }) {
                        HStack {
                            Text("Media Options")
                            Spacer()
                            Text(selectedDuration.label)
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .background(Color.defaultAppGray)
                        .cornerRadius(12)
                        .foregroundColor(.defaultAppWhite)
                    }
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Benefits")
                        .font(.headline)
                        .foregroundColor(.defaultAppWhite)

                    Text("Meditation helps reduce stress, improves concentration, and increases self-awareness. Practice daily for best results.")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("How to practice")
                        .font(.headline)
                        .foregroundColor(.defaultAppWhite)

                    Text("Find a quiet place, sit comfortably, and focus on your breath. Allow thoughts to pass without judgment.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .sheet(isPresented: $showOptionsSheet) {
            OptionsBottomSheet()
        }
        .sheet(isPresented: $showGuideSheet) {
            GuideBottomSheetView(selectedGuide: $selectedGuide)
        }
        .sheet(isPresented: $showMediaOptions) {
            MediaOptionsPopup(selectedDuration: $selectedDuration)
        }
        .fullScreenCover(isPresented: $showPlayer) {
            MeditationPlayerView(isPresented: $showPlayer, title: meditation.title, subtitle: meditation.subtitle)
                .environmentObject(progressModel)
        }
    }
}

// MARK: - Fixes for Errors

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}







// MARK: - Preview
struct MeditationsView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationsView()
    }
}

struct OptionsBottomSheet: View {
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.5))
                .padding(.top, 10)

            HStack(spacing: 12) {
                Image("meditation_cover")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(10)

                VStack(alignment: .leading) {
                    Text("Psalm 6: Distress")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    Text("Minute Psalm · 2 min")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()

            VStack(spacing: 0) {
                ForEach(optionItems, id: \.self) { item in
                    Button {
                        // handle action
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: item.icon)
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                            Text(item.title)
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                    }
                }
            }
            Spacer()
        }
        .padding(.bottom, 16)
        .background(Color.defaultAppDark)
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }

    struct OptionItem: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
    }

    let optionItems: [OptionItem] = [
        .init(icon: "heart", title: "Favorite"),
        .init(icon: "plus", title: "Add to Routine"),
        .init(icon: "play.fill", title: "Play"),
        .init(icon: "square.stack", title: "Go to Collection"),
        .init(icon: "quote.bubble", title: "Add a Reflection"),
        .init(icon: "arrow.down.circle", title: "Download Audio"),
        .init(icon: "square.and.arrow.up", title: "Share")
    ]
}


// MARK: - MediaOptionsPopup
struct MediaOptionsPopup: View {
    @Binding var selectedDuration: DurationOption
    let durations = [6, 11, 15]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    // UIApplication.shared.mineFrameDynasty()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding(10)
                }
            }
            .padding(.trailing)
            .padding(.top)

            Text("Media Options")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .padding(.bottom, 20)

            VStack(spacing: 12) {
                ForEach(durations, id: \.self) { duration in
                    DurationOptionButton(
                        duration: duration,
                        isSelected: selectedDuration.rawValue == String(duration)
                    ) {
                        if let option = DurationOption(rawValue: String(duration)) {
                            selectedDuration = option
                        }
                    }
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.bottom, 16)
        .background(Color.defaultAppDark)
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }
}

// Вспомогательная сабвью
struct DurationOptionButton: View {
    let duration: Int
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text("\(duration) min")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
}
struct GuideBottomSheetView: View {
    struct Guide: Identifiable {
        let id = UUID()
        let name: String
        let subtitle: String
        let imageName: String
    }

    let guides: [Guide] = [
        Guide(name: "Jonathan", subtitle: "Heartfelt and Engaging", imageName: "person.circle.fill"),
        Guide(name: "Anna", subtitle: "Gentle and Reassuring", imageName: "person.circle.fill"),
        Guide(name: "Francis", subtitle: "Deliberate and Calm", imageName: "person.circle.fill"),
        Guide(name: "Abby", subtitle: "Casual and Warm", imageName: "person.circle.fill")
    ]

    @Binding var selectedGuide: GuideOption

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Guide")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .padding(.top)

            ForEach(guides) { guide in
                HStack(spacing: 16) {
                    Image(systemName: guide.imageName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.gray))

                    VStack(alignment: .leading) {
                        Text(guide.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        Text(guide.subtitle)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Button(action: {
                        if let option = GuideOption(rawValue: guide.name) {
                            selectedGuide = option
                        }
                    }) {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(selectedGuide.rawValue == guide.name ? .blue : .white)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(.sRGB, red: 28/255, green: 28/255, blue: 30/255, opacity: 1))
        .cornerRadius(20)
    }
}

import SwiftUI
import AVFoundation

struct MeditationPlayerView: View {
    @Binding var isPresented: Bool
    let title: String
    let subtitle: String
    @State private var hasRecordedMeditation = false
    @State private var isPlaying = true
    @State private var currentTime: Double = 0.0
    @State private var duration: Double = 0.0
    @State private var player: AVPlayer = AVPlayer()
    @State private var isSeeking = false
    @EnvironmentObject var progressModel: AppProgressModel
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                        .padding(.top, 50)
                        .padding(.trailing, 15)
                }
            }

            Spacer()

            Image(systemName: "person.crop.square")
                .resizable()
                .frame(width: 150, height: 150)
                .padding()

            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .padding(.bottom, 2)

            Text(subtitle)
                .font(.system(size: 14))
                .foregroundColor(.gray)

            Slider(value: Binding(
                get: { self.currentTime },
                set: { newValue in
                    self.currentTime = newValue
                    isSeeking = true
                    seek(to: newValue)
                }),
                   in: 0...duration
            )
            .accentColor(.white)
            .padding()

            HStack {
                Text(formatTime(currentTime))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Spacer()
                Text("-\(formatTime(max(duration - currentTime, 0)))")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)

            HStack(spacing: 40) {
                Button(action: {
                    let newTime = max(currentTime - 10, 0)
                    seek(to: newTime)
                }) {
                    Image(systemName: "gobackward.10")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }

                Button(action: {
                    isPlaying.toggle()
                    isPlaying ? player.play() : player.pause()
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                }

                Button(action: {
                    let newTime = min(currentTime + 10, duration)
                    seek(to: newTime)
                }) {
                    Image(systemName: "goforward.10")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            }
            .padding(.top)

            Spacer()
        }
        .background(Color(.sRGB, red: 215/255, green: 93/255, blue: 93/255, opacity: 1))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player.pause()
        }
    }

    private func setupPlayer() {
        guard let url = Bundle.main.url(forResource: "track", withExtension: "mp4") else {
            print("track.mp4 not found in bundle")
            return
        }

        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)

        // ✅ Загрузка duration с использованием нового API
        Task {
            do {
                let duration = try await item.asset.load(.duration)
                await MainActor.run {
                    self.duration = duration.seconds
                }
            } catch {
                print("Failed to load duration: \(error)")
            }
        }

        // ✅ Обновление currentTime с MainActor
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { time in
            Task { @MainActor in
                self.currentTime = time.seconds//Main actor-isolated property 'currentTime' can not be mutated from a Sendable closure
                
                if !hasRecordedMeditation && duration > 0 && time.seconds >= duration / 2 { //Main actor-isolated property 'duration' can not be referenced from a nonisolated autoclosure //Main actor-isolated property 'hasRecordedMeditation' can not be referenced from a Sendable closure
                    hasRecordedMeditation = true//Main actor-isolated property 'hasRecordedMeditation' can not be mutated from a Sendable closure
                    let today = Date()
                    progressModel.recordMeditation(on: today)//Main actor-isolated property 'progressModel' can not be referenced from a Sendable closure
                }
            }
        }

        player.play()
    }

    private func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player.seek(to: cmTime) { _ in
            DispatchQueue.main.async {
                self.isSeeking = false
            }
        }
    }
    private func formatTime(_ time: Double) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
extension OptionsBottomSheet.OptionItem: Hashable {}
extension Color {
    static let defaultAppDark = Color("defaultDark")
    static let defaultAppWhite = Color("defaultWhite")
    static let defaultAppGray = Color("defaultGray")
}

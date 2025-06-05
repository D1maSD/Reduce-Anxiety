// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Reduce-Anxiety",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppChatView",
            targets: ["AppChatView"]),
        .library(
                   name: "AppTabBar",
                   targets: ["AppTabBar"]),
        .library(
                   name: "AppLoginFlow",
                   targets: ["AppLoginFlow"]),
        .library(
                   name: "AppMainScreen",
                   targets: ["AppMainScreen"]),
        .library(
                   name: "AppMeditaion+Attention",
                   targets: ["AppMeditaion+Attention"]),
        .library(
                   name: "AppOnboarding",
                   targets: ["AppOnboarding"]),
        .library(
                   name: "AppPsychologistChat",
                   targets: ["AppPsychologistChat"]),
        .library(
                   name: "AppNotePad",
                   targets: ["AppNotePad"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        
        .target(
            name: "AppTabBar"),
        .target(
            name: "AppLoginFlow"),
        .target(
            name: "AppMainScreen"),
        .target(
            name: "AppMeditaion+Attention"),
        .target(
            name: "AppPsychologistChat"),
        .target(
            name: "AppChatView"),
        .target(
            name: "AppOnboarding"),
        .target(
            name: "AppNotePad")
        
    ]
)

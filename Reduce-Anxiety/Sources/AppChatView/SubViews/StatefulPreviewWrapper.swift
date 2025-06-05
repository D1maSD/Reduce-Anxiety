//
//  StatefulPreviewWrapper.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 5/24/25.
//

import SwiftUI
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

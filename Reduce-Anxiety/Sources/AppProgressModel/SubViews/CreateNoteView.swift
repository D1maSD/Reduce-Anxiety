//
//  NotesScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/8/25.
//

import SwiftUI

struct CreateNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var noteText: String = """
Trics
Interview tasks

Docker
Toist - for Xcode project assembly
POSTMAN
Additional tools for developer
"""

    var onSave: (Note) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                RichTextEditor(text: $noteText)
                    .frame(maxHeight: .infinity)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .foregroundColor(.white)

                Button(action: {
                    let newNote = Note(date: Date(), text: noteText)
                    onSave(newNote)
                    dismiss()
                }) {
                    Text("Save")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.defaultSelected)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Notes")
                        }
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.defaultSelected)
                    }
                }
            }
            .background(Color.black.ignoresSafeArea())
            .onAppear {
                print("CreateNoteView opened")
            }
        }
    }
}




#Preview {
    CreateNoteView { note in
        print("Saved note: \(note)")
    }
}

struct RichTextEditor: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.keyboardDismissMode = .interactive
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.white,                // 👈 цвет текста
                .font: UIFont.systemFont(ofSize: 16)            // 👈 базовый шрифт
            ]
        )

        let lines = text.components(separatedBy: "\n")
        if let firstLine = lines.first {
            let firstLineRange = (text as NSString).range(of: firstLine)
            attributed.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 28), range: firstLineRange)
        }

        uiView.attributedText = attributed
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor

        init(_ parent: RichTextEditor) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}


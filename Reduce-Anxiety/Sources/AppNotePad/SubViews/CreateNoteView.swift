//
//  NotesScreen.swift
//  Reduce Anxiety
//
//  Created by Dima Melnik on 4/8/25.
//

import SwiftUI

struct CreateNoteView: View {
    @State private var noteText: String = ""
    var onSave: (Note) -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("New Note")
                .font(.title2)
                .fontWeight(.semibold)

            TextField("Write something...", text: $noteText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save") {
                let newNote = Note(date: Date(), text: noteText)
                onSave(newNote)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.yellow)
            .cornerRadius(10)
            .foregroundColor(.black)
        }
        .padding()
    }
}



//#Preview {
//    CreateNoteView()
//}

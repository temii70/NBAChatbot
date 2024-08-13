//
//  ViewControlScreen.swift
//  LLM
//
//  Created by Temi Otun on 2024-08-02.

import SwiftUI

struct ViewControlScreen: View {
    @State var HomeScreen = false
    @State var scaleAmount: CGFloat = 1 // for precision

    var body: some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)

            if HomeScreen {
                ContentView()
            } else {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit) // Better to use .fit instead of .fill for logos
                    .frame(width: 200, height: 100)
                    .scaleEffect(scaleAmount)
                    .onAppear {
                        runAnimations()
                    }
            }
        }
    }

    // Function to handle the animations
    private func runAnimations() {
        // First animation: Shrinks the logo
        withAnimation(.easeOut(duration: 1)) {
            scaleAmount = 0.6
        }

        // Second animation: Enlarges the logo after a short delay
        withAnimation(.easeInOut(duration: 15).delay(1)) {
            scaleAmount = 300
        }

        // Transition to the home screen after 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            withAnimation {
                HomeScreen = true
            }
        }
    }
}

struct ViewControlScreen_Preview: PreviewProvider {
    static var previews: some View {
        ViewControlScreen()
    }
}

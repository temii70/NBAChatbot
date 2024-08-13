//
//  NBAChatbotApp.swift
//  NBAChatbot
//
//  Created by Temi Otun on 2024-08-12.
//

import SwiftUI
import Firebase

@main
struct NBAChatbotApp: App {
    @StateObject var viewModel = AuthView()
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            
            ViewControlScreen()
                .environmentObject(viewModel)
        }
    }
}

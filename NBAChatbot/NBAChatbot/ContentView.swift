//
//  ContentView.swift
//  LLM
//
//  Created by Temi Otun on 2024-07-26.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var viewModel: AuthView

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.userSession != nil {
                    ChatbotView()
                        .environmentObject(viewModel)  // Ensure the environment object is passed down
                } else {
                    ZStack {
                        Image("Mike")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all)

                        VStack {
                            Spacer().frame(height: 100)
                            Text("NBA Chatbot")
                                .font(.system(size: 40, weight: .heavy, design: .monospaced))
                                .foregroundColor(.white)
                                .padding(.top, 50)
                            
                            Spacer()

                            HStack {
                                
                                NavigationLink(destination: AboutView2()) {
                                    Text("About")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                        .background(Color.gray)
                                        .cornerRadius(10)
                                }
                                
                                Spacer().frame(width: 40)

                                NavigationLink(destination: Login()) {
                                    Text("Login")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                        .background(Color.gray)
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal, 50)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthView())
    }
}


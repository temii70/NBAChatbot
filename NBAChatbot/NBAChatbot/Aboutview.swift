//
//  TestingAbout.swift
//  LLM
//
//  Created by Temi Otun on 2024-07-29.
//

import Foundation
import SwiftUI

struct AboutView2: View {
    var body: some View {
        ZStack{
            Image("Mike")
                .resizable()
                .aspectRatio(contentMode:.fill)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack(){
                Spacer().frame(height:175)
               
                    Text("About the NBA Chatbot")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top,100)
                        .padding(.horizontal, 10)
//                        .border(.gray)
//                    TextField("$yourBindingHere")
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                
                
                    
                    Spacer()
                    Text("This app was created by a basketball fan for Basketball fans. Using the Chatter bot Library, you can ask the Chat bot questions about Nba players and Nba Teams. I hope you enjoy it!")
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)//centers the text
                        .background(Color.black.opacity(0.7))
                        .frame(width:400,height:100)
                        .cornerRadius(50)
                Spacer().frame(height:130)
                
                        

                
                   
            }.padding()
            
        }
      
    }
}


#Preview {
    AboutView2()
}


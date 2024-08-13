//
//  ChatbotView.swift
//  LLM
//
//  Created by Temi Otun on 2024-08-01.
//

import SwiftUI


struct Message: Identifiable{
    let id = UUID()//makes it unique
    let text: String
    let isUser: Bool //to determine if its the user message
    
    
    
}

struct ChatbotView: View {
    @EnvironmentObject var viewModel : AuthView
    @State private var messages: [Message] = [] // Constantly being updated/mutable
    @State private var User_Input = ""
    @State private var navigateToLoginView = false  // State variable for navigation

    var body: some View {
        ZStack {
            Image("Ball")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .aspectRatio(contentMode: .fill)
            
            VStack {
                HStack {
                    Spacer()
                    Button("Sign Out") {
                        viewModel.signOut()
                        navigateToLoginView = true  // Trigger navigation after signing out
                    }
                    .foregroundColor(.white)
                    .fontWeight(.black)
                    .padding(.trailing, 24)
                }
                
                ScrollView {  // Scrollable view
                    ForEach(messages) { message in
                        HStack {
                            if message.isUser {  // Check if the message is from the user
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray)
                                    .cornerRadius(20)
                                    .foregroundColor(.black)
                            } else {  // Message from the chatbot
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray)
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }.padding()
                    }
                }
                
                HStack(spacing: 0) {
                    TextField("Message NBAChatbot", text: $User_Input, axis: .vertical)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(40)
                    
                    Button(action: sendMessage) {
                        Image("Arrowkey")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .padding(.trailing)
                }.padding(.horizontal)
            }
        }
        .navigationDestination(isPresented: $navigateToLoginView) {
            Login()  //takes user to the login view when pressed
        }
    }

    
    func sendMessage() {
        guard !User_Input.isEmpty else { return } //if user input is not empty so user is saying something
        
        let userMessage = Message(text: User_Input, isUser: true) //text is the userinput and isUser is true
        messages.append(userMessage) //add to the array of messages
        User_Input = "" //clears the message
        
        // Call the Flask backend to get the chatbot's response
        getResponse(User_Input: userMessage.text) { response in
            let botMessage = Message(text: response, isUser: false)
            messages.append(botMessage)//response is in the array messages
        }
    }
    
    func getResponse(User_Input: String, completion: @escaping (String) -> Void) { //bot's response after
        guard let URL = URL(string: "http://127.0.0.1:5000/chat") else { return } //creates the URL link
        
        var request = URLRequest(url: URL) //requesting the url from above
        request.httpMethod = "POST" //defining the method for it
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") //tells the server the body is a JSON file
        
        let body: [String: String] = ["message": User_Input] //creates dictionary
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) //body of the HTTP request if it doesn't work it returns NIL
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let responseDict = try? JSONSerialization.jsonObject(with: data) as? [String: String],
                  let botResponse = responseDict["response"] else { return } //chained guard statement, returns nil if any step fails
            
            DispatchQueue.main.async {                completion(botResponse)//makes it run on the main thread
            }
        }.resume() //starts the network
        
    }
}


struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView()
    }
}

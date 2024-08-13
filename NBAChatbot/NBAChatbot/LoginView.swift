//
//  Login.swift
//  LLM
//
//  Created by Temi Otun on 2024-07-29.
//https://www.youtube.com/watch?v=l7obVQObdRM<reference video


import SwiftUI


struct Login: View {
    //mutable state to modify the variables
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var navigateToChatbot = false
    @State private var navigateToRegistrationView = false
    //available to any view that needs it and is constant
    @EnvironmentObject var viewModel: AuthView

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Mike")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
                
                VStack {
                    Spacer().frame(height: 100)
                    
                    Text("Login")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                        .padding()

                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white.opacity(0.75))
                        .cornerRadius(20)
                        .autocapitalization(.none)

                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white.opacity(0.75))
                        .cornerRadius(20)

                    if isLoading {
                        //while it is loading
                        ProgressView()
                            .frame(width: 300, height: 50)
                            .background(Color.black)
                            .cornerRadius(50)
                    } else {
                        //calls the sign in function
                        Button("Sign In") {
                            signIn()
                        }
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.black)
                        .cornerRadius(50)
                        //this will allow the user to Sign in when the other inputs are completed
                        .disabled(!formisvalid)
                        //changes the opacity depending if the inputs are completed
                        .opacity(formisvalid ? 1 : 0.5)
                    }

                  
                    HStack(spacing: 0) {
                        Button(action: {
                            
                            navigateToRegistrationView = true
                        }) {
                            Text("Create User")
                                .foregroundColor(.black)
                                .background(Color.white)
                                .cornerRadius(60)
                                .fontWeight(.black)
                                .fontWidth(.standard)
                        }
                        Spacer().frame(width: 40)
                        
                        Button(action: {//takes the user to the chatbot view if they do not want to create a account
                            navigateToChatbot = true
                        }) {
                            Text("Continue as Guest")
                                .foregroundColor(.black)
                                .background(Color.white)
                                .cornerRadius(60)
                                .fontWeight(.black)
                                .fontWidth(.standard)
                        }
                    }
                    .padding(.horizontal, 50)
                    .padding(.bottom, 100)
                }
                
                //if navigate to chatbot is on it will give the chatbot view
                .navigationDestination(isPresented: $navigateToChatbot) {
                    ChatbotView()
                }
                //takes the user to the registration view
                .navigationDestination(isPresented: $navigateToRegistrationView) {
                    RegistrationView()
                }
            }
        }
    }

    func signIn() {
        isLoading = true
        errorMessage = ""
        
        Task {
            do {// used a do because it might throw an error
               
                // trys to sign in asynchronously The code will pause here and won't continue until the signIn function completes successfully or throws an error.

                try await viewModel.signIn(email: email, password: password)
                isLoading = false
                // Navigate to ChatbotView if sign-in is successful
                if viewModel.userSession != nil {
                    navigateToChatbot = true
                }
            } catch {
                errorMessage = "Failed to log in: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}

extension Login: AuthenticationFormProtocol {
    //creates a variable where the textfields must answered for it to be true and allow the user to click the button
    var formisvalid: Bool {
        return !email.isEmpty &&
            email.contains("@") &&
            !password.isEmpty &&
            password.count > 6
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
            .environmentObject(AuthView())
    }
}


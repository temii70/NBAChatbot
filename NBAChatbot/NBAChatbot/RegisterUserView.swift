//
//  database.swift
//  LLM
//
//  Created by Temi Otun on 2024-08-03.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var emailaddress = ""
    @State private var password = ""
    @State private var confirmpassword = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var navigateToChatbot = false
    @EnvironmentObject var viewModel: AuthView

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Kobe")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    HStack {
                        Text("First Name")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.leading, 20)

                    TextField("Enter first name", text: $firstname)
                        .padding()
                        .frame(width: 400, height: 50)
                        .background(Color.white.opacity(0.80))
                        .cornerRadius(20)

                    HStack {
                        Text("Last Name")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.leading, 20)

                    TextField("Enter Last Name", text: $lastname)
                        .padding()
                        .frame(width: 400, height: 50)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(20)

                    HStack {
                        Text("Email Address")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.leading, 20)

                    TextField("Enter email address", text: $emailaddress)
                        .padding()
                        .frame(width: 400, height: 50)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(20)

                    HStack {
                        Text("Create Password")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.leading, 20)

                    TextField("Enter Password", text: $password)
                        .padding()
                        .frame(width: 400, height: 50)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(20)

                    HStack {
                        Text("Confirm Password")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.leading, 20)

                    TextField("Enter Password", text: $confirmpassword)
                        .padding()
                        .frame(width: 400, height: 50)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(20)

                    if isLoading {
                        ProgressView()
                            .frame(width: 350, height: 70)
                    } else {
                        Button("Create Account") {
                            createUser()
                        }
                        .frame(width: 350, height: 70)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(20)
                        //disables the button at first untill formisvalid is true
                        .disabled(!formisvalid)
                        .opacity(formisvalid ? 1 : 0.5)
                        .padding(10)
                    }
                    //if theres a error message the screen will display it
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }

                    HStack(spacing: 5) {
                        Text("Already have an account?")
                            .foregroundColor(.white)
                        //sends the user to the Log in view
                        NavigationLink("Log In", value: "login")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .underline()
                    }
                    //after the signup function is called it will send the user to the chatbot view
                    .navigationDestination(isPresented: $navigateToChatbot) {
                        ChatbotView()
                    }
                }
            }
        }
    }

    func createUser() {
        isLoading = true
        errorMessage = ""

        Task {
            do {
                //creating the user through firebase
                try await viewModel.createUser(email: emailaddress, password: password, fullname: firstname + " " + lastname)
                isLoading = false
                
                navigateToChatbot = true
            } catch {
                errorMessage = "Failed to create account: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formisvalid: Bool {
        return !emailaddress.isEmpty &&
            emailaddress.contains("@") &&
            !password.isEmpty &&
            password.count > 6 &&
            password == confirmpassword
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
        //creates a instance of the Authview class
            .environmentObject(AuthView())
    }
}

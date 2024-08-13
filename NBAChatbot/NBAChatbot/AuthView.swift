//
//  AuthView.swift
//  LLM
//
//  Created by Temi Otun on 2024-08-06.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol{
    //return true if all the variables are true
    var formisvalid: Bool {get}
    
    
}

//tells swift that this function should be executed on the main thread

@MainActor

class AuthView : ObservableObject {
    //creates a a observable object view so the view is automatically updated when its changed it can either store a firebase object or nil
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        
        //if a user is signed in  it will return the current user else it will return nil
        self.userSession = Auth.auth().currentUser
        
        Task  { //getting more information about the user  while letting swift run without blocking the main thread
            
           await fetchUser()
       }
       

    }
    
    
    
    
    func signIn(email:String, password: String)async throws{
        do{
            //trying to sign the user in and if it doesnt work it will catch the error
            
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            //setting the user session to the result
            self.userSession = result.user
            await fetchUser()
            
        }
        catch{
            print("Failed to log in with error:\(error.localizedDescription)")
            
            
        }
        
        
        
        
    }
    
    
    
    func createUser(email:String, password: String, fullname: String)async throws {
        do {
            
            //trying to create a user using Firebase
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            //setting the user session to result
            self.userSession = result.user
            
            //creating a new user
            let user = User(id :result.user.uid, fullname: fullname, email: email)
            
            
            try await saveUser(user: user)
            await fetchUser()
        }
        
        //catching the error
        catch{
            print("There was a error: \(error.localizedDescription)")
        }
        
        
        
    }
    
    
    
    func saveUser(user:User) async throws{
        
        //accessing Firebase's NoSQL cloud database service
        let db = Firestore.firestore()
        //waits for the database to create the users name and email
        try await db.collection("users").document(user.id).setData([
            "id": user.id,
            "fullname": user.fullname,
            "email": user.email
        ])
        
        
        
    }
    
    func signOut(){
        do {
            //clears both user session and current user
                   try Auth.auth().signOut()
                   self.userSession = nil
                   self.currentUser = nil
                   print("User signed out")
               } catch {
                   print("Failed to sign out with error: \(error.localizedDescription)")
               }
           }

    
    func fetchUser() async{
        // gets the current user's id
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let db = Firestore.firestore()
        do{
            
            
            //gets the user's unique id from the database and stores the current user as the retrieved user's information
            let document = try await db.collection("users").document(uid).getDocument()
            self.currentUser = try document.data(as:User.self)
        }
        catch{
            print("Error getting user:\(error.localizedDescription)")
        }
    }
}


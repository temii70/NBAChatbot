//
//  User.swift
//  LLM
//
//  Created by Temi Otun on 2024-08-08.
//

import Foundation
struct User: Identifiable, Codable { //creates a unique user struct with a id to track each item uniquely
let id: String
let fullname : String
let email: String
    
    
    var intials: String{//creates a computed property which calculates and returns the value when its called
        
        let formatter =  PersonNameComponentsFormatter()//calls the built in class in swift that breaks a persons name into its parts
        if let components = formatter.personNameComponents(from: fullname){//only works if the code is not null
            formatter.style = .abbreviated
            return formatter.string(from: components)// converts to a string
        }
        
        return "" //returns this if its a empty string
        
    }
    
}

extension User{
    
    
}

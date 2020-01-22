//
//  User.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 31/10/19.
//  Copyright © 2019 Kostas Poimenidis. All rights reserved.
//

import Foundation

class User {
    
    var id : String
    var email : String
    var username : String
    var imageUrl : String
    
    init(id: String, email: String, username: String){
        self.id = id
        self.email = email
        self.username = username
        self.imageUrl = ""
    }
    
    init(id: String, username: String, imageUrl: String){
        self.id = id
        self.email = ""
        self.username = username
        self.imageUrl = imageUrl
    }
    
    
}

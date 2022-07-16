//
//  Contact.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-13.
//

import Foundation
import Firebase

struct Contact{

    let ref : DatabaseReference?
    let key : String
    
    var firstName: String
    var lastName: String
    var emailAddress: String
    var number: Int
    var id: String
    
    init(key: String = "", firstName: String, lastName: String, emailAddress: String, number: Int, id: String){
        self.ref = nil
        self.key = key
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.number = number
        self.id = id
    }
    
    init?(snapshot: DataSnapshot){
        guard
            let value = snapshot.value as? [String: AnyObject],
            let firstName = value["firstName"] as? String,
            let lastName = value["lastName"] as? String,
            let emailAddress = value["emailAddress"] as? String,
            let number = value["number"] as? Int,
            let id = value["id"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.number = number
        self.id =  id
    }
    
    
    func toAnyObject() -> Any {
        return [
            "firstName" : firstName,
            "lastName" : lastName,
            "emailAddress" : emailAddress,
            "number" : number,
            "id" : id
        ]
    }
    
}

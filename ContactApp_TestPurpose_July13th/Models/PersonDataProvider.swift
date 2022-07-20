//
//  MyProfile.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-17.
//

import Foundation

struct PersonDataProvider {
    static func dataProvider() -> [(String, String)] {
        return [
            ("First name", "ex.) John"),
            ("Last name", "ex.) Smith"),
            ("Email", "ex.) test@example.com"),
            ("Phone Number", "ex.) 1111111111")
        ]
    }
    
    static func myProfileDataProvider() -> [(String, String)] {
        return [
            ("First name", "ex.) John"),
            ("Last name", "ex.) Smith"),
            ("Email", "ex.) test@example.com"),
            ("Phone Number", "ex.) 1111111111"),
            ("Logout", "Logout"),
            ("Account", "Delete Account")
        ]
    }
}

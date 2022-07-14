//
//  StorageManager.swift
//  ContactApp_TestPurpose_July13th
//
//  Created by Apple New on 2022-07-14.
//

import Foundation
import FirebaseStorage

//Get, fetch, upload files to firebase storage
class StorageManager {
    
    //=========== Elements ===========
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    private init(){}
    
    
    // ========== Functions ==========
    public func uploadProfilePicture(with data : Data, fileName: String){
        
        storage.child("images/" + fileName).putData(data, metadata: nil, completion:{ [weak self]
            metadata, error in
            
            guard let self = self else { return }
            
            print("fileName: \(fileName)")
            guard error == nil else {
                print("failed to upload data to firebase for picture.")
                return
            }
            print("succeeded in uploading a picture")
            self.storage.child("images/" + fileName).downloadURL(completion: { url, error in
                guard let url = url else {
                    print("images/\(fileName)")
                    print("failed to get download url. S")
                    return
                }
                let urlString = url.absoluteString
               print("download url returned: \(urlString)")
            })
        })
 
    }

}


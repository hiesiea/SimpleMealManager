//
//  FirebaseData.swift
//  SimpleMealManager
//
//  Created by Hitoshi KAMADA on 2019/09/15.
//  Copyright © 2019 hitoshi.kamada. All rights reserved.
//

import Firebase

class FirebaseData {
    private static let PostPath = "posts"
    private static let StorageUrl = "gs://simplemealmanager-3df92.appspot.com/"
    
    static func getUser() -> User? {
        return Auth.auth().currentUser
    }
    
    static func getPostsDatabaseReferenceLogout() -> DatabaseReference {
        return Database.database().reference().child(PostPath)
    }
    
    static func getPostsDatabaseReference(uid: String) -> DatabaseReference {
        return Database.database().reference().child(PostPath).child(uid)
    }
    
    static func getPostsStorageReference(uid: String) -> StorageReference {
        return Storage.storage().reference(forURL: StorageUrl).child(PostPath).child(uid)
    }
}

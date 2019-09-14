//
//  FirebaseData.swift
//  SimpleMealManager
//
//  Created by Hitoshi KAMADA on 2019/09/15.
//  Copyright © 2019 hitoshi.kamada. All rights reserved.
//

import Firebase

struct FirebaseData {
    static func getUser() -> User? {
        return Auth.auth().currentUser
    }
    
    static func getPostsDatabaseReferenceLogout() -> DatabaseReference {
        return Database.database().reference().child(Const.PostPath)
    }
    
    static func getPostsDatabaseReference(uid: String) -> DatabaseReference {
        return Database.database().reference().child(Const.PostPath).child(uid)
    }
    
    static func getPostsStorageReference(uid: String) -> StorageReference {
        return Storage.storage().reference(forURL: Const.StorageUrl).child(Const.PostPath).child(uid)
    }
}

//
//  FirebaseData.swift
//  SimpleMealManager
//
//  Created by Hitoshi KAMADA on 2019/09/15.
//  Copyright © 2019 hitoshi.kamada. All rights reserved.
//

import Firebase
import RxFirebase

class FirebaseData {
    private static let PostPath = "posts"
    private static let StorageUrl = "gs://simplemealmanager-3df92.appspot.com/"
    
    private(set) var database: DatabaseReference
    private(set) var storage: StorageReference

    init(uid: String) {
        database = Database.database().reference().child(FirebaseData.PostPath).child(uid)
        storage = Storage.storage().reference(forURL: FirebaseData.StorageUrl).child(FirebaseData.PostPath).child(uid)
    }
}

//
//  FirebaseData.swift
//  SimpleMealManager
//
//  Created by Hitoshi KAMADA on 2019/09/15.
//  Copyright © 2019 hitoshi.kamada. All rights reserved.
//

import Firebase
import RxFirebase
import RxSwift

class FirebaseData {
    private static let PostPath = "posts"
    private static let StorageUrl = "gs://simplemealmanager-3df92.appspot.com/"
    private let disposeBag = DisposeBag()
    
    private var user: User?
    private var database: DatabaseReference
    private var storage: StorageReference
    
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
    
    init() {
        user = Auth.auth().currentUser
        database = Database.database().reference().child(FirebaseData.PostPath).child(user!.uid)
        storage = Storage.storage().reference(forURL: FirebaseData.StorageUrl).child(FirebaseData.PostPath).child(user!.uid)
    }
    
    func update(id: String, values: [AnyHashable: Any], onSuccess: @escaping() -> Void) {
        database.child(id).rx.updateChildValues(values)
            .subscribe({ _ in
                // Success
                onSuccess()
            }).disposed(by: disposeBag)
    }
}

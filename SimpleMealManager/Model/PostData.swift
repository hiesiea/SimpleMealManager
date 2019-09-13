//
//  PostData.swift
//  SimpleMealManager
//
//  Created by Hitoshi KAMADA on 2019/09/08.
//  Copyright © 2019 hitoshi.kamada. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String?
    var image: UIImage?
    var imageUrl: String?
    var comment: String?
    var date: Date?
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        print("snapshot.key = \(snapshot.key), myId = \(myId)")
        
        let valueDictionary = snapshot.value as! [String: Any]
        
        imageUrl = valueDictionary["imageUrl"] as? String
        let url = URL(string: imageUrl!)
        do {
            let data = try Data(contentsOf: url!)
            image = UIImage(data: data)
            
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        
        self.comment = valueDictionary["comment"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
    }
    
    func formatDatetoString() -> String {
        if self.date == nil {
            return ""
        }
        
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        return f.string(from: self.date!)
    }
}

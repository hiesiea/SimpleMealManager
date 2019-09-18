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
    var imageUrl: String?
    var title: String?
    var comment: String?
    var date: Date?
    private var image: UIImage?
    
    init(snapshot: DataSnapshot) {
        self.id = snapshot.key
        print("snapshot.key = \(snapshot.key)")
        
        let valueDictionary = snapshot.value as! [String: Any]
        
        self.imageUrl = valueDictionary["imageUrl"] as? String
        self.title = valueDictionary["title"] as? String
        self.comment = valueDictionary["comment"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
    }
    
    // URLから実データを生成
    func getUIImage() -> UIImage? {
        if self.image == nil {
            let url = URL(string: imageUrl!)
            do {
                let data = try Data(contentsOf: url!)
                self.image = UIImage(data: data)
            } catch let err {
                print("Error : \(err.localizedDescription)")
                return nil
            }
        }
        return self.image
    }
    
    // フォーマット済みの日付を返す
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
    
    // シェア用のメッセージを返す
    func getShareMessage() -> String {
        var shareMessage = String()
        if !self.title!.isEmpty {
            shareMessage.append("料理名：\(self.title!)\n")
        }
        if !self.comment!.isEmpty {
            shareMessage.append("コメント：\(self.comment!)\n")
        }
        shareMessage.append(self.imageUrl!)
        return shareMessage
    }
}

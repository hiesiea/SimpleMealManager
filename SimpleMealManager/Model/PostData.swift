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
        id = snapshot.key
        print("snapshot.key = \(snapshot.key)")
        
        let valueDictionary = snapshot.value as! [String: Any]
        
        imageUrl = valueDictionary["imageUrl"] as? String
        title = valueDictionary["title"] as? String
        comment = valueDictionary["comment"] as? String
        
        let time = valueDictionary["time"] as? String
        date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
    }
    
    // URLから実データを生成
    func getUIImage() -> UIImage? {
        if image == nil {
            let url = URL(string: imageUrl!)
            do {
                let data = try Data(contentsOf: url!)
                self.image = UIImage(data: data)
            } catch let err {
                print("Error : \(err.localizedDescription)")
                return nil
            }
        }
        return image
    }
    
    // フォーマット済みの日付を返す
    func formatDatetoString() -> String {
        if date == nil {
            return ""
        }
        
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        return f.string(from: date!)
    }
    
    // シェア用のメッセージを返す
    func getShareMessage() -> String {
        var shareMessage = String()
        if title!.isEmpty {
            shareMessage.append("料理名：\(title!)\n")
        }
        if comment!.isEmpty {
            shareMessage.append("コメント：\(comment!)\n")
        }
        shareMessage.append(imageUrl!)
        return shareMessage
    }
}

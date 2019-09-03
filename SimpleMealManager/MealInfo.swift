//
//  MealInfo.swift
//  SimpleMealManager
//
//  Created by Hitoshi KAMADA on 2019/09/03.
//  Copyright © 2019 hitoshi.kamada. All rights reserved.
//

import RealmSwift

class MealInfo: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    // 日時
    @objc dynamic var date = Date()
    
    // 緯度
    @objc dynamic var latitude = 0.0
    
    // 経度
    @objc dynamic var longitude = 0.0
    
    // 画像
    @objc dynamic var image = NSData()
    
    // コメント
    @objc dynamic var comment = ""
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}

//
//  EditViewController.swift
//  SimpleMealManager
//
//  Created by Hitoshi KAMADA on 2019/09/10.
//  Copyright © 2019 hitoshi.kamada. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class EditViewController: UIViewController {
    @IBOutlet weak var commentTextView: UITextView!
    
    var selectedPost: PostData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedPost != nil {
            commentTextView.text = selectedPost?.comment
        }
        
        let saveButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(handleSaveButton(_:)))
        
        //ナビゲーションバーの右側にボタン付与
        self.navigationItem.setRightBarButtonItems([saveButton], animated: true)
    }
    
    @objc func handleSaveButton(_ sender: UIBarButtonItem) {
        let postRef = Database.database().reference().child(Const.PostPath).child(selectedPost!.id!)
        let comment = ["comment": commentTextView.text]
        postRef.updateChildValues(comment as [AnyHashable : Any])
        print("\(selectedPost!.id!)を編集")
        self.navigationController?.popToRootViewController(animated: true)
        // HUDで完了を知らせる
        SVProgressHUD.showSuccess(withStatus: "編集しました")
    }
}

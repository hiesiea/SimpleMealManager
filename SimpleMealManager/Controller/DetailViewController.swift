//
//  DetailViewController.swift
//  SimpleMealManager
//
//  Created by Hitoshi KAMADA on 2019/09/06.
//  Copyright © 2019 hitoshi.kamada. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    
    var selectedPost: PostData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedPost != nil {
            imageView.image = selectedPost?.image
            commentTextView.text = selectedPost?.comment
        }
        
        let editButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(handleEditButton(_:)))
        
        //ナビゲーションバーの右側にボタン付与
        self.navigationItem.setRightBarButtonItems([editButton], animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit" {
            let editViewController = segue.destination as! EditViewController
            editViewController.selectedPost = sender as? PostData
        }
    }
    
    @IBAction func handleDeleteButton(_ sender: Any) {
        Database.database().reference().child(Const.PostPath).child(selectedPost!.id!).removeValue()
        print("\(selectedPost!.id!)を削除")
        self.navigationController?.popToRootViewController(animated: true)
        // HUDで完了を知らせる
        SVProgressHUD.showSuccess(withStatus: "削除しました")
    }
    
    @objc func handleEditButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Edit", sender: self.selectedPost)
    }
}

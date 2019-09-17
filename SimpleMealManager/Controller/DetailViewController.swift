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
        
        if self.selectedPost != nil {
            // 選択された内容をViewに反映
            self.imageView.image = self.selectedPost?.getUIImage()
            self.commentTextView.text = self.selectedPost?.comment
            if self.commentTextView.text.isEmpty {
                self.commentTextView.text = "コメントが未記入です"
            }
            self.navigationItem.title = self.selectedPost?.formatDatetoString()
        } else {
            // ホーム画面に戻る
            self.navigationController?.popToRootViewController(animated: true)
            SVProgressHUD.showError(withStatus: "読み込みに失敗しました")
        }
        
        // 戻るボタンをナビゲーションバーに追加
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        
        // 編集ボタンをナビゲーションバーに追加
        let editButtonItem: UIBarButtonItem = UIBarButtonItem(title: "編集", style: .plain, target: self, action: #selector(handleEditButton(_:)))
        self.navigationItem.setRightBarButton(editButtonItem, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit" {
            let editViewController = segue.destination as! EditViewController
            editViewController.selectedPost = sender as? PostData
        }
    }
    
    @IBAction func handleShareButton(_ sender: Any) {
        let shareAlert: UIAlertController = UIAlertController(title: "シェア", message: "シェア方法を選択してください", preferredStyle:  UIAlertController.Style.actionSheet)
        
        let twitterAction: UIAlertAction = UIAlertAction(title: "Twitter", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            let urlString = "https://twitter.com/intent/tweet?text=\(self.selectedPost!.getShareMessage())"
            let encodedText = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let encodedText = encodedText,
                let url = URL(string: encodedText) {
                UIApplication.shared.open(url)
            }
        })
        
        let lineAction: UIAlertAction = UIAlertAction(title: "LINE", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            let urlString = "line://msg/text/?\(self.selectedPost!.getShareMessage())"
            let encodedText = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let encodedText = encodedText,
                let url = URL(string: encodedText) {
                print(url)
                UIApplication.shared.open(url)
            }
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        shareAlert.addAction(twitterAction)
        shareAlert.addAction(lineAction)
        shareAlert.addAction(cancelAction)
        
        self.present(shareAlert, animated: true, completion: nil)
    }
    
    @IBAction func handleDeleteButton(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "削除", message: "削除してもよろしいですか？", preferredStyle: UIAlertController.Style.actionSheet)
        
        let deleteAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            if FirebaseData.getUser() == nil {
                print("削除失敗 ユーザがいない")
                SVProgressHUD.showSuccess(withStatus: "削除に失敗しました")
            }
            let storageRef = FirebaseData.getPostsStorageReference(uid: FirebaseData.getUser()!.uid)
            storageRef.child(self.selectedPost!.id! + Const.ImageExtension).delete { error in
                if let error = error {
                    print("削除失敗 \(error.localizedDescription)")
                    SVProgressHUD.showSuccess(withStatus: "削除に失敗しました")
                } else {
                    let databaseRef = FirebaseData.getPostsDatabaseReference(uid: FirebaseData.getUser()!.uid)
                    databaseRef.child(self.selectedPost!.id!).removeValue()
                    print("\(self.selectedPost!.id!)を削除")
                    SVProgressHUD.showSuccess(withStatus: "削除しました")
                    // ホーム画面に戻る
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        })
        
        let cancelAlert = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
            (action: UIAlertAction!) in
            print("キャンセル")
        })
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAlert)
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    @objc func handleEditButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Edit", sender: self.selectedPost)
    }
}

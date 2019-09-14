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
            self.imageView.image = self.selectedPost?.image
            self.commentTextView.text = self.selectedPost?.comment
            self.navigationItem.title = self.selectedPost?.formatDatetoString()
        } else {
            // ホーム画面に戻る
            self.navigationController?.popToRootViewController(animated: true)
            SVProgressHUD.showError(withStatus: "読み込みに失敗しました")
        }
        
        // 編集ボタン
        let editButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(handleEditButton(_:)))
        self.navigationItem.setRightBarButtonItems([editButton], animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit" {
            let editViewController = segue.destination as! EditViewController
            editViewController.selectedPost = sender as? PostData
        }
    }
    
    @IBAction func handleShareButton(_ sender: Any) {
        if self.selectedPost!.comment!.isEmpty {
            SVProgressHUD.showError(withStatus: "コメントがありません")
            return
        }
        
        let alert: UIAlertController = UIAlertController(title: "シェア", message: "シェア方法を選択してください", preferredStyle:  UIAlertController.Style.actionSheet)
        let photoLibraryAction: UIAlertAction = UIAlertAction(title: "Twitter", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            let comment = self.selectedPost!.comment!
            let urlString = "https://twitter.com/intent/tweet?text=\(comment)"
            let encodedText = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let encodedText = encodedText,
                let url = URL(string: encodedText) {
                UIApplication.shared.open(url)
            }
        })
        let cameraAction: UIAlertAction = UIAlertAction(title: "LINE", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            let comment = self.selectedPost!.comment!
            let urlString = "line://msg/text/?\(comment)"
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
        
        alert.addAction(photoLibraryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func handleDeleteButton(_ sender: Any) {
        let actionSheet = UIAlertController(title: "削除", message: "削除してもよろしいですか？", preferredStyle: UIAlertController.Style.actionSheet)
        
        let action = UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            let storageRef = Storage.storage().reference(forURL: Const.StorageUrl).child(Const.PostPath)
            storageRef.child(self.selectedPost!.id! + Const.ImageExtension).delete { error in
                if let error = error {
                    print("削除失敗 \(error.localizedDescription)")
                    SVProgressHUD.showSuccess(withStatus: "削除に失敗しました")
                } else {
                    Database.database().reference().child(Const.PostPath).child(self.selectedPost!.id!).removeValue()
                    print("\(self.selectedPost!.id!)を削除")
                    SVProgressHUD.showSuccess(withStatus: "削除しました")
                    // ホーム画面に戻る
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        })
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
            (action: UIAlertAction!) in
            print("キャンセル")
        })
        
        actionSheet.addAction(action)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func handleEditButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "Edit", sender: self.selectedPost)
    }
}

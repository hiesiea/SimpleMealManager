//
//  EditViewController.swift
//  SimpleMealManager
//
//  Created by Hitoshi KAMADA on 2019/09/10.
//  Copyright © 2019 hitoshi.kamada. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var commentTextView: InspectableTextView!
    
    // 選択された投稿情報
    var selectedPost: PostData? = nil
    
    private let firebaseData = FirebaseData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.selectedPost != nil {
            // 選択された内容をViewに反映
            self.titleTextField.text = selectedPost?.title
            self.commentTextView.text = selectedPost?.comment
            self.commentTextView.togglePlaceholder()
            self.navigationItem.title = "編集"
        } else {
            // ホーム画面に戻る
            self.navigationController?.popToRootViewController(animated: true)
            SVProgressHUD.showError(withStatus: "読み込みに失敗しました")
        }
        
        // 保存ボタン
        let saveButtonItem: UIBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(handleSaveButton(_:)))
        self.navigationItem.setRightBarButtonItems([saveButtonItem], animated: true)
    }
    
    @objc func handleSaveButton(_ sender: UIBarButtonItem) {
        // DBにコメントを更新する
        let comment = ["title": titleTextField.text, "comment": commentTextView.text]
        firebaseData.update(id: selectedPost!.id!, values: comment as [AnyHashable : Any]) {
            print("\(self.selectedPost!.id!)を編集")

            // ホーム画面に戻る
            self.navigationController?.popToRootViewController(animated: true)
            SVProgressHUD.showSuccess(withStatus: "編集しました")
        }
    }
}

//
//  ViewController.swift
//  SimpleMealManager
//
//  Created by Hitoshi KAMADA on 2019/08/31.
//  Copyright © 2019 hitoshi.kamada. All rights reserved.
//

import ESTabBarController
import UIKit
import Firebase
import SVProgressHUD

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let homeViewController: UIViewController? = {
        // ViewControllerを設定する
        let homeStoryBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = homeStoryBoard.instantiateInitialViewController()
        return viewController
    }()
    
    private let loginViewController: UIViewController? = {
        // ViewControllerを設定する
        let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = loginStoryBoard.instantiateInitialViewController()
        return viewController
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
    }
    
    private func setupTab() {
        // 画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home", "photo"])
        
        // 背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        tabBarController.selectionIndicatorHeight = 3
        
        // 作成したESTabBarControllerを親のViewController（＝self）に追加する
        addChild(tabBarController)
        let tabBarView = tabBarController.view!
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            ])
        tabBarController.didMove(toParent: self)
        
        tabBarController.setView(homeViewController, at: 0)
        
        // 真ん中のタブはボタンとして扱う
        tabBarController.highlightButton(at: 1)
        tabBarController.setAction({
            // ライブラリ（カメラロール）を指定してピッカーを開く
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
            
        }, at: 1)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.originalImage] != nil {
            let image = info[.originalImage] as! UIImage
            print("DEBUG_PRINT: image = \(image)")
            
            let imageData = image.jpegData(compressionQuality: 0.5)
            let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
            
            // postDataに必要な情報を取得しておく
            let time = Date.timeIntervalSinceReferenceDate
            
            // 辞書を作成してFirebaseに保存する
            let postRef = Database.database().reference().child(Const.PostPath)
            let postDic = ["image": imageString, "time": String(time), "comment": String()]
            postRef.childByAutoId().setValue(postDic)
            
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
        } else {
            SVProgressHUD.showSuccess(withStatus: "投稿に失敗しました")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

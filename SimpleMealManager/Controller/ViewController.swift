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
    
    private let settingViewController: UIViewController? = {
        // ViewControllerを設定する
        let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Setting", bundle: nil)
        let viewController = loginStoryBoard.instantiateInitialViewController()
        return viewController
    }()
    
    private var esTabBarController: ESTabBarController? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            self.present(self.loginViewController!, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.originalImage] != nil {
            let image = info[.originalImage] as! UIImage
            print("DEBUG_PRINT: image = \(image)")
            let resizeWidth = image.size.width / 5
            let resizeHeight = image.size.height / 5
            let resizeImage = image.resize(size: CGSize(width: resizeWidth, height: resizeHeight))
            uploadImage(image: resizeImage!)
        } else {
            SVProgressHUD.showError(withStatus: "投稿に失敗しました")
        }
        picker.dismiss(animated: true, completion: nil)
        esTabBarController?.setSelectedIndex(0, animated: false)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func setupTab() {
        // 画像のファイル名を指定してESTabBarControllerを作成する
        esTabBarController = ESTabBarController(tabIconNames: ["home", "camera", "setting"])
        
        // 背景色、選択時の色を設定する
        esTabBarController?.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        esTabBarController?.buttonsBackgroundColor = UIColor(red: 249, green: 249, blue: 249, alpha: 1)
        esTabBarController?.selectionIndicatorHeight = 3
        
        // 作成したESTabBarControllerを親のViewController（＝self）に追加する
        addChild(esTabBarController!)
        let tabBarView = esTabBarController?.view!
        tabBarView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView!)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            (tabBarView?.topAnchor.constraint(equalTo: safeArea.topAnchor))!,
            (tabBarView?.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor))!,
            (tabBarView?.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor))!,
            (tabBarView?.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor))!,
            ])
        esTabBarController?.didMove(toParent: self)
        
        esTabBarController?.setView(self.homeViewController, at: 0)
        esTabBarController?.setView(self.settingViewController, at: 2)
        
        // 真ん中のタブはボタンとして扱う
        esTabBarController?.highlightButton(at: 1)
        esTabBarController?.setAction({
            self.displayAlert()
        }, at: 1)
    }
    
    private func displayAlert() {
        let alert: UIAlertController = UIAlertController(title: "投稿", message: "投稿方法を選択してください", preferredStyle:  UIAlertController.Style.actionSheet)
        let photoLibraryAction: UIAlertAction = UIAlertAction(title: "フォトライブラリ", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            // ライブラリ（カメラロール）を指定してピッカーを開く
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
        })
        let cameraAction: UIAlertAction = UIAlertAction(title: "カメラ", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            // カメラを指定してピッカーを開く
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
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
    
    //Storageに画像を保存する
    private func uploadImage(image: UIImage) {
        // HUDで処理中を表示
        SVProgressHUD.show()
        
        if FirebaseData.getUser() == nil {
            print("ユーザがいない")
            SVProgressHUD.showError(withStatus: "投稿に失敗しました")
            return
        }
        let databaseRef = FirebaseData.getPostsDatabaseReference(uid: FirebaseData.getUser()!.uid)
        guard let key = databaseRef.childByAutoId().key else {
            print("keyの発行に失敗")
            SVProgressHUD.showError(withStatus: "投稿に失敗しました")
            return
        }
        
        let storageRef = FirebaseData.getPostsStorageReference(uid: FirebaseData.getUser()!.uid)
        let data = image.jpegData(compressionQuality: 0.7)! as Data
        
        // Upload the file
        storageRef.child(key + Const.ImageExtension).putData(data, metadata: nil) { (metadata, error) in
            
            // You can also access to download URL after upload.
            storageRef.child(key + Const.ImageExtension).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("保存失敗 \(error.debugDescription)")
                    SVProgressHUD.showError(withStatus: "投稿に失敗しました")
                    return
                }
                // postDataに必要な情報を取得しておく
                let time = Date.timeIntervalSinceReferenceDate
                let imageUrl = downloadURL.absoluteString
                
                // 辞書を作成してFirebaseに保存する
                let postDic = ["imageUrl": imageUrl, "time": String(time), "comment": String()]
                databaseRef.child(key).setValue(postDic)
                print("保存されました！")
                
                // HUDで処理中を表示
                SVProgressHUD.dismiss()
            }
        }
    }
}

extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}

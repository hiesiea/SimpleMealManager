//
//  SettingViewController.swift
//  SimpleMealManager
//
//  Created by Hitoshi KAMADA on 2019/09/08.
//  Copyright © 2019 hitoshi.kamada. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {
    
    private let loginViewController: UIViewController? = {
        // ViewControllerを設定する
        let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = loginStoryBoard.instantiateInitialViewController()
        return viewController
    }()
    
    @IBAction func handleLogoutButton(_ sender: Any) {
        // ログアウトする
        try! Auth.auth().signOut()
        
        // HUDで完了を知らせる
        SVProgressHUD.showSuccess(withStatus: "ログアウトしました")
        
        // ログイン画面を表示する
        self.present(self.loginViewController!, animated: true, completion: nil)
        
        // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
        let esTabBarController = parent as! ESTabBarController
        esTabBarController.setSelectedIndex(0, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

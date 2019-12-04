//
//  LoginViewController.swift
//  SimpleMealManager
//
//  Created by Hitoshi KAMADA on 2019/09/06.
//  Copyright © 2019 hitoshi.kamada. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import RxFirebase
import RxSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let disposeBag = DisposeBag()
    
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            
            // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            // HUDで処理中を表示
            SVProgressHUD.show()
            
            Auth.auth().rx.signIn(withEmail: address, password: password)
                .subscribe(onNext: { authResult in
                    print("DEBUG_PRINT: ログインに成功しました")
                    
                    // HUDを消す
                    SVProgressHUD.dismiss()
                    self.clearTextField()
                    
                    // 画面を閉じてViewControllerに戻る
                    self.dismiss(animated: true, completion: nil)
                }, onError: { error in
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました")
                }).disposed(by: disposeBag)
        }
    }
    
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let mailAddress = mailAddressTextField.text, let password = passwordTextField.text {
            
            // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if mailAddress.isEmpty || password.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です")
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            // HUDで処理中を表示
            SVProgressHUD.show()
            
            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().rx.createUser(withEmail: mailAddress, password: password)
                .subscribe(onNext: { authResult in
                    print("DEBUG_PRINT: ユーザー作成に成功しました")
                    
                    // HUDを消す
                    SVProgressHUD.dismiss()
                    self.clearTextField()
                    
                    // 画面を閉じてViewControllerに戻る
                    self.dismiss(animated: true, completion: nil)
                }, onError: { error in
                    // エラーがあったら原因をprint
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました")
                }).disposed(by: disposeBag)
        }
    }
    
    private func clearTextField() {
        mailAddressTextField.text = ""
        passwordTextField.text = ""
    }
}

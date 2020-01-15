# SimpleMealManager

## App Store

[‎「かんたん食事管理」をApp Storeで](https://apps.apple.com/jp/app/%E3%81%8B%E3%82%93%E3%81%9F%E3%82%93%E9%A3%9F%E4%BA%8B%E7%AE%A1%E7%90%86/id1482117628)

## ライブラリ、FW

- [Firebase(Authentication、Realtime Database、Storage)](https://firebase.google.com/?hl=ja)
- [RxSwiftCommunity/RxFirebase: RxSwift extensions for Firebase](https://github.com/RxSwiftCommunity/RxFirebase)
- [eggswift/ESTabBarController: ESTabBarController is a Swift model for customize UI, badge and adding animation to tabbar items. Support lottie!](https://github.com/eggswift/ESTabBarController)
- [SVProgressHUD/SVProgressHUD: A clean and lightweight progress HUD for your iOS and tvOS app.](https://github.com/SVProgressHUD/SVProgressHUD)
- [dzenbot/DZNEmptyDataSet: A drop-in UITableView/UICollectionView superclass category for showing empty datasets whenever the view has no content to display](https://github.com/dzenbot/DZNEmptyDataSet)

## 前提条件

- Xcodeのバージョンが最新（2020年1月時点で11.3）であること

## 事前準備

### Firebase

1. [Firebase](https://firebase.google.com/?hl=ja)でアカウントを作成
2. Firebaseプロジェクト作成
3. プロジェクト設定
- ログイン プロバイダは、「メール / パスワード」を有効にする
- Realtime Databaseは、ルールを以下のように設定しておく

```
{
  "rules": {
    // 以下のルールに一致しないものはデフォルトですべて読み書き拒否
    ".read": false,
    ".write": false,

    // 投稿用共有フォルダ
    "posts": {
      // ユーザーID毎
      "$uid": {
        // /posts/$uid の$uidとログイン中のUIDが一致すれば読み書き可
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

- Storageは、Rulesを以下のように設定しておく

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /posts {
     match /{allPosts=**} {
       allow read;
       allow write: if request.auth != null;
     }
   }
 }
}
```

### CocoaPods
1. CocoaPodsのインストール
```
sudo gem install cocoapods
pod setup
```
2. ```pod install```コマンドでライブラリのインストール

## テストユーザ情報

| メールアドレス | パスワード |
| ---- | ---- |
| test@test.jp | testtest |
| test2@test.jp | testtest |

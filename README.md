# SimpleMealManager

## 前提条件

- Xcodeのバージョンが11.2であること

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

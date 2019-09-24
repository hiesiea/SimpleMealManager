//
//  HomeViewController.swift
//  SimpleMealManager
//
//  Created by Hitoshi KAMADA on 2019/09/05.
//  Copyright © 2019 hitoshi.kamada. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ESTabBarController
import DZNEmptyDataSet

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 投稿データ
    private var postArray: [PostData] = []
    
    // DatabaseのobserveEventの登録状態を表す
    private var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // レイアウトを調整
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.collectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if FirebaseData.getUser() != nil {
            if self.observing == false {
                
                // HUDで処理中を表示
                SVProgressHUD.show()
                
                // 要素が追加されたらpostArrayに追加してTableViewを再表示する
                let databaseRef = FirebaseData.getPostsDatabaseReference(uid: FirebaseData.getUser()!.uid)
                databaseRef.observeSingleEvent(of: .value) { snapshot in
                    print("DEBUG_PRINT: .valueイベントが発生しました")
                    if (snapshot.childrenCount < 1) {
                        print("DEBUG_PRINT: データがありません")
                        
                        // HUDで処理中を表示
                        SVProgressHUD.dismiss()
                    }
                }
                databaseRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました")
                    if (FirebaseData.getUser()?.uid) != nil {
                        let postData = PostData(snapshot: snapshot)
                        self.postArray.insert(postData, at: 0)
                        
                        // TableViewを再表示する
                        self.collectionView.reloadData()
                        
                        // HUDで処理中を表示
                        SVProgressHUD.dismiss()
                    }
                })
                databaseRef.observe(.childRemoved, with: { snapshot in
                    print("DEBUG_PRINT: .childRemovedイベントが発生しました")
                    if (FirebaseData.getUser()?.uid) != nil {
                        let postData = PostData(snapshot: snapshot)
                        
                        // 保持している配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id == postData.id {
                                index = self.postArray.firstIndex(of: post)!
                                break
                            }
                        }
                        
                        // 削除する
                        self.postArray.remove(at: index)
                        
                        // TableViewを再表示する
                        self.collectionView.reloadData()
                    }
                })
                // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                databaseRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました")
                    if (FirebaseData.getUser()?.uid) != nil {
                        let postData = PostData(snapshot: snapshot)
                        
                        // 保持している配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id == postData.id {
                                index = self.postArray.firstIndex(of: post)!
                                break
                            }
                        }
                        
                        // 差し替えるため一度削除する
                        self.postArray.remove(at: index)
                        
                        // 削除したところに更新済みのデータを追加する
                        self.postArray.insert(postData, at: index)
                        
                        // TableViewを再表示する
                        self.collectionView.reloadData()
                    }
                })
                
                // DatabaseのobserveEventが上記コードにより登録されたため
                // trueとする
                self.observing = true
            }
        } else {
            if self.observing == true {
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
                // テーブルをクリアする
                self.postArray = []
                self.collectionView.reloadData()
                
                // オブザーバーを削除する
                let databaseRef = FirebaseData.getPostsDatabaseReferenceLogout()
                databaseRef.removeAllObservers()
                
                // DatabaseのobserveEventが上記コードにより解除されたため
                // falseとする
                self.observing = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.selectedPost = sender as? PostData
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        // Tag番号を使ってImageViewのインスタンス生成
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.image = self.postArray[indexPath.row].getUIImage()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 12
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Detail", sender: self.postArray[indexPath.row])
    }
}

extension HomeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    /// データが空の状態の時に表示したい属性付きタイトル文字列
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "データがありません")
    }
}

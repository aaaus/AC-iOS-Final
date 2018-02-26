//
//  FeedVC.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    private var cellSpacing = UIScreen.main.bounds.width * 0.05
    private var posts: [Post] = [] {
        didSet {
            feedCollectionView.reloadData()
        }
    }
    private var databaseService: DatabaseService!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseService = DatabaseService()
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        refreshControl.addTarget(self, action: #selector(getPosts), for: .valueChanged)
        feedCollectionView.refreshControl = refreshControl
        feedCollectionView.alwaysBounceVertical = true
        getPosts()
    }
    
    @objc private func getPosts() {
        databaseService.getPosts { [weak self] (posts) in
            self?.refreshControl.endRefreshing()
            if let posts = posts {
                self?.posts = posts.reversed() //get newest posts first
            } else {
                let errorAlert = Alert.createErrorAlert(withMessage: "Could not get posts!! Check your internet and try again.", andCompletion: nil)
                self?.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        AuthUserService.manager.signOut { [weak self] (didSignOut) in
            if didSignOut {
                let successAlert = Alert.createSuccessAlert(withMessage: "You signed out smh 😒", andCompletion: { (_) in
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                })
                self?.present(successAlert, animated: true, completion: nil)
            } else {
                let errorAlert = Alert.createErrorAlert(withMessage: "Could not sign out... try closing the app and trying again.", andCompletion: nil)
                self?.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let numberOfCells: CGFloat = 1
        let numberOfSpaces: CGFloat = numberOfCells + 1
        let width = (collectionView.frame.width - (cellSpacing * numberOfSpaces)) / numberOfCells
        
        //get height of cell using commentLabel's height
        //idea taken from - https://stackoverflow.com/questions/45204283/collectionview-dynamic-height-with-swift-3-in-ios
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        let size = CGSize(width: width, height: collectionView.frame.height)
        let estimatedFrame = NSString(string: posts[indexPath.row].comment).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGSize(width: width, height: (estimatedFrame.height + 16 + collectionView.frame.width))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
    }
}

extension FeedVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedCell
        let post = posts[indexPath.row]
        
        cell.configureCell(withPost: post)
        
        return cell
    }
}

//
//  FeedCell.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit
import Kingfisher

class FeedCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.borderWidth = 1.0

    }
    
    public func configureCell(withPost post: Post) {
        commentLabel.text = post.comment
        
        guard let imageURL = post.imageURL else {
            postImageView.image = #imageLiteral(resourceName: "placeholder")
            self.layoutIfNeeded()
            return
        }
        postImageView.kf.indicatorType = .activity
        postImageView.kf.setImage(with: imageURL as Resource, placeholder: #imageLiteral(resourceName: "placeholder"), options: nil, progressBlock: nil) { (image, error, _, _) in
            if let _ = image {
                print("got image!!")
            } else if let error = error {
                print("could not set image: \(error)")
            }
        }
    }
}

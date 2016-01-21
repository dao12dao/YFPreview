//
//  PrviewTableViewCell.swift
//  YFPreview
//
//  Created by iCanong on 16/1/21.
//  Copyright © 2016年 yufan. All rights reserved.
//

import UIKit

class PrviewTableViewCell: UITableViewCell {

    var img: UIImage? {
        didSet {
            productImageView.image = img
        }
    }
    
    private var productImageView = UIImageView()
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    private var nameLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
        
        
        nameLabel.font = UIFont.systemFontOfSize(17)
        nameLabel.textColor = UIColor.grayColor()
        nameLabel.textAlignment = .Left
        addSubview(nameLabel)
        
        addSubview(productImageView)
        
    }
    
    override func layoutSubviews() {
        nameLabel.frame = CGRect(x: 70, y: 0, width: frame.size.width, height: frame.size.height)
        productImageView.frame = CGRect(x: 10, y: 8, width: 50, height: 49)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}

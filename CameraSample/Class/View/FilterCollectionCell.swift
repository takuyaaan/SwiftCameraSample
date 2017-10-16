//
//  FilterCollectionCell.swift
//  CameraSample
//
//  Created by TakuyaMano on 2017/10/10.
//  Copyright © 2017年 TakuyaMano. All rights reserved.
//

import UIKit

class FilterCollectionCell: UICollectionViewCell {
    var label : UILabel!
    var image : UIImageView!

    func layoutViews(frame: CGRect) {
        label.frame = CGRect(x:0, y:0, width:frame.width,  height: frame.height/4)
        let size: CGFloat = (frame.height)*0.6
        image.frame = CGRect(x:0.0, y:frame.height/4, width:size,  height: size)
        image.contentMode = .scaleAspectFit
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
        
        label = UILabel(frame: CGRect(x:0, y:0, width:self.frame.width,  height: self.frame.height/4))
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label!)
        let size: CGFloat = (self.frame.height/4)*3
        image = UIImageView(frame: CGRect(x:0, y:self.frame.height/4, width:size,  height: size))
        self.addSubview(image!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

}

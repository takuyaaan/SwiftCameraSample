//
//  CheckBox.swift
//  CameraSample
//
//  Created by TakuyaMano on 2017/10/16.
//  Copyright © 2017年 TakuyaMano. All rights reserved.
//

import UIKit

struct CheckBoxColors {
    let ovalColor: UIColor
    let ovalFrameColor: UIColor
    let checkColor: UIColor
    
    static let primary = CheckBoxColors(
        ovalColor: UIColor.primary,
        ovalFrameColor: UIColor.primary,
        checkColor: UIColor.white
    )
    static let gray = CheckBoxColors(
        ovalColor: UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.2),
        ovalFrameColor: UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.3),
        checkColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    )
}

class CheckBox: UIView {
    
    private var isSelected = false
    
    convenience init(frame: CGRect, selected: Bool) {
        self.init(frame: frame)
        self.isSelected = selected
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        let checkMarkRect = CGRect(x: 5, y: 5, width: rect.width - 10, height: rect.height - 10)
        let checkBoxColors = isSelected ? CheckBoxColors.primary : CheckBoxColors.gray
        
        let oval = UIBezierPath(ovalIn: checkMarkRect)
        checkBoxColors.ovalColor.setFill()
        oval.fill()
        checkBoxColors.ovalFrameColor.setStroke()
        oval.lineWidth = 1
        oval.stroke()
        
        let xx = checkMarkRect.origin.x
        let yy = checkMarkRect.origin.y
        let width = checkMarkRect.width
        let height = checkMarkRect.height
        let checkmark = UIBezierPath()

        checkmark.move(to: CGPoint(x: xx + width / 6, y: yy + height / 2))
        checkmark.addLine(to: CGPoint(x: xx + width / 3, y: yy + height * 7 / 10))
        checkmark.addLine(to: CGPoint(x: xx + width * 5 / 6, y: yy + height * 1 / 3))
        checkBoxColors.checkColor.setStroke()
        checkmark.lineWidth = 4
        checkmark.stroke()
    }
}

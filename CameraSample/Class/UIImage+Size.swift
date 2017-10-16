//
//  UIImage+Size.swift
//  CameraSample
//
//  Created by TakuyaMano on 2017/10/11.
//  Copyright © 2017年 TakuyaMano. All rights reserved.
//

import UIKit

extension UIImage {

    func squareCropping() -> UIImage {
        // croped square
        guard let cgImage = self.cgImage else {
            return self
        }
        
        var resizeWidth:Int = cgImage.width, resizeHeight:Int = cgImage.height
        if (cgImage.width < cgImage.height) {
            resizeWidth = cgImage.width
            resizeHeight = cgImage.height * resizeWidth / cgImage.width
        } else {
            resizeHeight = cgImage.height
            resizeWidth = cgImage.width * resizeHeight / cgImage.height
        }
        
        let resizeSize = CGSize(width: CGFloat(resizeWidth), height: CGFloat(resizeHeight))
        UIGraphicsBeginImageContext(resizeSize)
        self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: resizeSize))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let srcSize = CGSize(width: resizeWidth, height: resizeHeight)
        let dstOrigin = CGPoint(x: 0.0, y: (srcSize.height - srcSize.width)/2.0)
        let dstSize = CGSize(width: srcSize.width, height: srcSize.width)
        let rect = CGRect(origin: dstOrigin, size: dstSize)
        guard let croppedImage = (resizeImage?.cgImage)!.cropping(to: rect) else {
            return self
        }
        return UIImage(cgImage: croppedImage)
    }

    func resizeImage(ratio: CGFloat) -> UIImage {
        let resizedSize = CGSize(width: Int(self.size.width * ratio), height: Int(self.size.height * ratio))
        UIGraphicsBeginImageContext(resizedSize)
        self.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func resizeImageCropping() -> UIImage {
        // croped square
        guard let cgImage = self.cgImage else {
            return self
        }

        var resizedImage = self
        var resizedSize = CGSize(width: CGFloat(cgImage.width), height: CGFloat(cgImage.height))
        if UIScreen.main.bounds.size.width < CGFloat(cgImage.width)
        || UIScreen.main.bounds.size.height < CGFloat(cgImage.height) {
            let ratioW = UIScreen.main.bounds.size.width / CGFloat(cgImage.width)
            let ratioH = UIScreen.main.bounds.size.height / CGFloat(cgImage.height)
            resizedSize = CGSize(width: Int(CGFloat(cgImage.width) * ratioW), height: Int(CGFloat(cgImage.height) * ratioH))
            UIGraphicsBeginImageContext(resizedSize)
            self.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
            resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        var originX: CGFloat = 0
        var originY: CGFloat = 0
        if (cgImage.width < cgImage.height) {
            originY = (resizedSize.height - resizedSize.width) / 2.0
        } else {
            originX = (resizedSize.width - resizedSize.height) / 2.0
        }
        let srcSize = CGSize(width: resizedSize.width, height: resizedSize.height)
        let dstOrigin = CGPoint(x: originX, y: originY)
        let dstSize = CGSize(width: srcSize.width, height: srcSize.width)
        let rect = CGRect(origin: dstOrigin, size: dstSize)
        guard let croppedImage = resizedImage.cgImage?.cropping(to: rect) else {
            return self
        }
        return UIImage(cgImage: croppedImage)
    }
    
}

//
//  ImageFilter.swift
//  CameraSample
//
//  Created by TakuyaMano on 2017/10/10.
//  Copyright © 2017年 TakuyaMano. All rights reserved.
//

import UIKit

class ImageFilter {

    fileprivate let filterList = [
        "No Filter",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CILinearToSRGBToneCurve",
        "CISRGBToneCurveToLinear"
    ]
    
    fileprivate let filterNameList = [
        "Normal",
        "Chrome",
        "Fade",
        "Instant",
        "Mono",
        "Noir",
        "Process",
        "Tonal",
        "Transfer",
        "Tone",
        "Linear"
    ]

    static let shared = ImageFilter()
    private init(){
        originImage = UIImage()
    }

    fileprivate let context = CIContext(options: nil)
    fileprivate var originImage: UIImage!
    fileprivate var filterImageList = [UIImage]()

    var originalImage: UIImage {
        get {
            if filterImageList.count > 1 {
                return filterImageList[0]
            }
            return originImage
        }
        set(image) {
            originImage = image

            filterImageList.removeAll()
            for filter in filterList {
                let filterImage = createFilteredImage(filter, image: image)
                let ratio = UIScreen.main.bounds.size.width / filterImage.size.width
                filterImageList.append(filterImage.resizeImage(ratio: ratio))
            }
        }
    }
    
    func filterCount() -> Int {

        return filterList.count
    }

    func filter(index: Int) -> String? {

        guard index < filterList.count else {
            return nil
        }
        return filterList[index]
    }

    func filterName(index: Int) -> String? {
        
        guard index < filterNameList.count else {
            return nil
        }
        return filterNameList[index]
    }

    func filterImage(index: Int) -> UIImage {

        guard index < filterImageList.count else {
            return originImage
        }
        return filterImageList[index]
    }

    func createFilteredImage(_ filterName: String, image: UIImage) -> UIImage {
        
        let sourceImage = CIImage(image: image)
        let filter = CIFilter(name: filterName)
        guard let _ = filter else {
            return image
        }
        filter?.setDefaults()
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)
        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
        let filteredImage = UIImage(cgImage: outputCGImage!)
        return filteredImage
    }

    func createFilteredImage(index: Int, image: UIImage) -> UIImage {

        let sourceImage = CIImage(image: image)
        let filter = CIFilter(name: filterList[index])
        filter?.setDefaults()
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)
        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
        let filteredImage = UIImage(cgImage: outputCGImage!)
        return filteredImage
    }
    
}

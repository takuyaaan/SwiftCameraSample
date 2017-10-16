//
//  EditImageViewController.swift
//  CameraSample
//
//  Created by TakuyaMano on 2017/10/06.
//  Copyright © 2017年 TakuyaMano. All rights reserved.
//

import UIKit

class EditImageViewController: UIViewController {

    fileprivate let slideAnimator = TransitionSlideAnimator()
    fileprivate let context = CIContext(options: nil)
    fileprivate var filterIndex = 0
    fileprivate var collectionOriginalImage: UIImage?
    fileprivate var thumbnailSize: CGSize!
    fileprivate var previousPreheatRect = CGRect.zero
    
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    fileprivate func filterItemSize() {
        
        let itemHeight = (collectionView?.frame.size.height)! * 0.8
        let itemSize = CGSize(width: itemHeight, height: itemHeight)
        
        if let layout = collectionViewLayout {
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = 3
            layout.minimumLineSpacing = 3
        }
        
        let scale = UIScreen.main.scale
        thumbnailSize = CGSize(width: itemSize.width * scale, height: itemSize.height * scale)
    }
    
    fileprivate func updateImage(index: Int) {
        imageView?.image = ImageFilter.shared.filterImage(index: index)
    }

// MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.transitioningDelegate = TransitionSlideAnimator()
        imageView?.image = ImageFilter.shared.originalImage
        imageView?.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterItemSize()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        filterItemSize()
    }
    
    override func updateViewConstraints() {
        let height = self.view.frame.size.height - scrollView.frame.size.height - kBottomBarHeight
        collectionView?.heightAnchor.constraint(equalToConstant: height).isActive = true
        super.updateViewConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension EditImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionCell", for: indexPath) as! FilterCollectionCell

        cell.layoutViews(frame: cell.frame)
        cell.image.image = ImageFilter.shared.filterImage(index: indexPath.row)
        cell.label.text = ImageFilter.shared.filterName(index: indexPath.row)
        updateCellFont()
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageFilter.shared.filterCount()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filterIndex = indexPath.row
//        if filterIndex != 0 {
//            applyFilter()
//        } else {
//            imageView?.image = image
//        }
        updateImage(index: filterIndex)
        updateCellFont()
        scrollCollectionViewToIndex(itemIndex: indexPath.item)
        // アルバムに追加.
        //        UIImageWriteToSavedPhotosAlbum(photo, self, nil, nil)
    }
    
    func updateCellFont() {
        // update font of selected cell
//        if let selectedCell = collectionView?.cellForItem(at: IndexPath(row: filterIndex, section: 0)) {
//            let cell = selectedCell as! SHCollectionViewCell
//            cell.filterNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
//        }
//
//        for i in 0...filterNameList.count - 1 {
//            if i != filterIndex {
//                // update nonselected cell font
//                if let unselectedCell = collectionView?.cellForItem(at: IndexPath(row: i, section: 0)) {
//                    let cell = unselectedCell as! SHCollectionViewCell
//                    if #available(iOS 8.2, *) {
//                        cell.filterNameLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightThin)
//                    } else {
//                        // Fallback on earlier versions
//                        cell.filterNameLabel.font = UIFont.systemFont(ofSize: 14.0)
//                    }
//                }
//            }
//        }
    }
    
    func scrollCollectionViewToIndex(itemIndex: Int) {

        let indexPath = IndexPath(item: itemIndex, section: 0)
        self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

//extension EditImageViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let height: CGFloat = collectionView.frame.size.height * 0.9
//        let width: CGFloat = height
//        return CGSize(width: width, height: height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(0.0 , 5.0 , 0.0 , 5.0 )  //マージン(top , left , bottom , right)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 5.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 5.0
//    }
//
//}


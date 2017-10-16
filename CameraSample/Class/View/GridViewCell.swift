/*
See LICENSE.txt for this sample’s licensing information.

Abstract:
Collection view cell for displaying an asset.
*/

import UIKit

class GridViewCell: UICollectionViewCell {

    var representedAssetIdentifier: String!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var livePhotoBadgeImageView: UIImageView!

    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    var livePhotoBadgeImage: UIImage! {
        didSet {
            livePhotoBadgeImageView.image = livePhotoBadgeImage
        }
    }

    private func setupCheckBox() {
        let boxWidth = frame.width * 0.5
        let boxRect = CGRect(origin: .zero, size: CGSize(width: boxWidth, height: boxWidth))
        
        checkBox = CheckBox(frame: boxRect, selected: true)
        checkBox.isHidden = !isSelected
        
        self.selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView?.backgroundColor = UIColor.primary
        
        self.addSubview(checkBox)
    }
    
    override var isSelected: Bool {
        didSet {
            checkBox.isHidden = !isSelected
            if oldValue != isSelected {
                // 変化あり
                let imageView = self.imageView
                if isSelected {
                    UIView.animate(withDuration: 0.05,
                                   animations: {
                                    imageView?.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                                },
                                   completion: { _ in
                                    UIView.animate(withDuration: 0.03) {
                                        imageView?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                                    }
                                }
                    )
                } else {
                    UIView.animate(withDuration: 0.04,
                                   animations: {
                                    imageView?.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
                                }, completion: { _ in
                                    UIView.animate(withDuration: 0.05) {
                                        imageView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                                    }
                                }
                    )
                }
            }
        }
    }

    private var checkBox: CheckBox!
    private var whiteLayer: CALayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCheckBox()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCheckBox()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage = nil
        livePhotoBadgeImageView.image = nil
        whiteLayer?.removeFromSuperlayer()
        whiteLayer = nil
        isUserInteractionEnabled = true
    }

    override var isUserInteractionEnabled: Bool {
        didSet {
            if isUserInteractionEnabled {
                whiteLayer?.removeFromSuperlayer()
                whiteLayer = nil
            } else {
                whiteLayer?.removeFromSuperlayer()
                let layer = CALayer()
                layer.frame = self.bounds
                layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7).cgColor
                self.layer.addSublayer(layer)
                whiteLayer = layer
            }
        }
    }
    
}

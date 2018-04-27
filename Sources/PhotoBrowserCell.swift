//
//  PhotoBrowserCell.swift
//  CWPhotoBrowserDemo
//
//  Created by chenwei on 2017/9/2.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit
import Kingfisher

protocol PhotoBrowserCellDelegate: NSObjectProtocol {
    /// 单击时回调
    func photoBrowserCellDidSingleTap(_ cell: PhotoBrowserCell)
}

public class PhotoBrowserCell: UICollectionViewCell {
    
    weak var delegate: PhotoBrowserCellDelegate?

    public var imageView = UIImageView()

    fileprivate var scrollView = UIScrollView()
    
    public var imageZoomScale: CGFloat = 2.0

    public var progressView = ProgressIndicator()
    
    /// 计算contentSize应处于的中心位置
    fileprivate var centerOfContentSize: CGPoint {
        let deltaWidth = bounds.width - scrollView.contentSize.width
        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
        let deltaHeight = bounds.height - scrollView.contentSize.height
        let offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0
        return CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX,
                       y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.contentView.backgroundColor = UIColor.clear

        // 设置scrollView
        scrollView.frame = self.contentView.bounds
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(scrollView)
        
        // progressView
        progressView.center = CGPoint(x: contentView.bounds.midX, y: contentView.bounds.midY)
        progressView.isHidden = true
        contentView.addSubview(progressView)
        
        // 设置imageView
        imageView.frame = self.contentView.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)
        
        // 双击手势
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
        
        // 单击手势
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(onSingleTap))
        contentView.addGestureRecognizer(singleTap)
        singleTap.require(toFail: doubleTap)
        
        // 拖动手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        scrollView.addGestureRecognizer(pan)
    }
    
    func setupScrollView() {
        
        guard let image = imageView.image else {
            return
        }
        
        scrollView.frame = contentView.bounds
        scrollView.setZoomScale(1.0, animated: false)

        // 需要判断横竖屏
        // 默认竖屏 需要按照宽度来计算 
        // 横屏需要按照高度来计算
        let size: CGSize
        let frame: CGRect
        // 竖屏
        if contentView.frame.width < contentView.frame.height {
            let width = scrollView.bounds.width
            let scale = image.size.height / image.size.width
            size = CGSize(width: width, height: ceil(scale * width)) 
            var margin = scrollView.bounds.height - size.height
            if margin > 0 {
                margin = margin*0.5
            } else {
                margin = 0
            }
            frame = CGRect(x: 0, y: margin, 
                           width: size.width, height: size.height)
        } else {
            let height = scrollView.bounds.height
            let scale = image.size.width / image.size.height
            size = CGSize(width: ceil(scale * height), height: height) 
            var margin = scrollView.bounds.width - size.width
            if margin > 0 {
                 margin = margin*0.5
            } else {
                margin = 0
            }
            frame = CGRect(x: margin, y: 0, 
                           width: size.width, height: size.height)
        }
        
        self.imageView.frame = frame
        self.scrollView.contentSize = size
        scrollView.setZoomScale(1.0, animated: false)
    }
    
    
    public func setImage(_ image: UIImage? = nil,
                         highQualityUrl: URL? = nil, 
                         originalUrl: URL? = nil) {

        
        self.loadImage(withPlaceholder: image, url: highQualityUrl)
        
    }
    
    /// 加载图片
    private func loadImage(withPlaceholder placeholder: UIImage?, url: URL?) {
        self.progressView.isHidden = false
        weak var weakSelf = self
        //let options: [KingfisherOptionsInfoItem] = [.cacheMemoryOnly]
        imageView.layer.removePreviousFadeAnimation()
        imageView.kf.setImage(with: url, placeholder: placeholder, options: nil, progressBlock: { (receivedSize, totalSize) in
            if totalSize > 0 {
                weakSelf?.progressView.progress = CGFloat(receivedSize) / CGFloat(totalSize)
            }
        }, completionHandler: { (image, error, cacheType, url) in
            weakSelf?.progressView.isHidden = true
            weakSelf?.imageView.layer.addFadeAnimation(withDuration: 0.25)
            weakSelf?.setupScrollView()
        })
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupScrollView()
    }
    
    // MARK: Action
    func originalImageButtonClick() {
        
        
        
    }
    
    @objc func onSingleTap() {
        delegate?.photoBrowserCellDidSingleTap(self)
    }
    
    @objc func onDoubleTap(_ doubleTap: UITapGestureRecognizer) {

        // 如果当前没有任何缩放，则放大到目标比例
        // 否则重置到原比例
        if scrollView.zoomScale == 1.0 {
            // 以点击的位置为中心，放大
            let pointInView = doubleTap.location(in: imageView)
            let w = scrollView.bounds.size.width / imageZoomScale
            let h = scrollView.bounds.size.height / imageZoomScale
            let x = pointInView.x - (w / 2.0)
            let y = pointInView.y - (h / 2.0)
            scrollView.zoom(to: CGRect(x: x, y: y, width: w, height: h), animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
        
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
    
    }
    
}

extension PhotoBrowserCell: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale <= 1.0 {
            imageView.center = centerOfContentSize
        }
    }
    
}

extension PhotoBrowserCell: UIGestureRecognizerDelegate {
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 只响应pan手势
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = pan.velocity(in: self)
        // 向上滑动时，不响应手势
        if velocity.y < 0 {
            return false
        }
        // 横向滑动时，不响应pan手势
        if abs(Int(velocity.x)) > Int(velocity.y) {
            return false
        }
        // 向下滑动，如果图片顶部超出可视区域，不响应手势
        if scrollView.contentOffset.y > 0 {
            return false
        }
        return true
    }
}


extension CALayer {
    
    func addFadeAnimation(withDuration duration: TimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionFade
        self.add(transition, forKey: "photobrowser.fade")        
    }
    
    func removePreviousFadeAnimation() {
        self.removeAnimation(forKey: "photobrowser.fade")
    }
    
}



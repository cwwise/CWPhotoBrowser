//
//  MomentsController.swift
//  CWPhotoBrowserDemo
//
//  Created by chenwei on 2017/9/3.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit
import Kingfisher
import CWPhotoBrowser

class MomentsController: UIViewController {

    var imagesViewArray: [UIImageView] = []
    
    fileprivate lazy var highQualityImageUrls: [String] = {
        return ["https://image.cwwise.com/cwwechat001.jpg",
                "https://image.cwwise.com/cwwechat002.jpg",
                "https://image.cwwise.com/cwwechat003.jpg",
                "https://image.cwwise.com/cwwechat004.jpg",
                "https://image.cwwise.com/cwwechat005.jpg",
                "https://image.cwwise.com/cwwechat006.jpg",
                "https://image.cwwise.com/cwwechat007.jpg",
                "https://image.cwwise.com/cwwechat008.jpg",
                "https://image.cwwise.com/cwwechat009.jpg"]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenWidth = UIScreen.main.bounds.width
        
        let top: CGFloat = 40
        let left: CGFloat = 15
        let space: CGFloat = 10
        
        
        let width = ceil((screenWidth - 2*left - 2*space)/3)
        
        for i in 0..<highQualityImageUrls.count {
            
            let column = CGFloat(i % 3)
            let row = CGFloat(i / 3)
            
            let imageView = UIImageView()
            let frame = CGRect(x: left + (width+space)*column, y: top+(width+space)*row, width: width, height: width)
            imageView.frame = frame
            imageView.contentMode = .scaleAspectFit;
            imageView.tag = i+100;
            imageView.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
            imageView.addGestureRecognizer(tap)
            
            let imageURL = URL(string: highQualityImageUrls[i])
            imageView.kf.setImage(with: imageURL)
            
            self.view.addSubview(imageView)
            imagesViewArray.append(imageView)
        }
    }

    func tapAction(_ tap: UITapGestureRecognizer) {
        
        guard let imageView = tap.view as? UIImageView, tap.state == .ended else {
            return
        } 
                   
        let photoBrowser = PhotoBrowser()
        photoBrowser.presentingVC = self
        photoBrowser.currentIndex = imageView.tag - 100
        photoBrowser.photoBrowserDelegate = self
        photoBrowser.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MomentsController: PhotoBrowserDelegate {
    /// 实现本方法以返回默认图所在view，在转场动画完成后将会修改这个view的hidden属性
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewAt index: Int) -> UIImageView? {
        return imagesViewArray[index]

    }

    
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return highQualityImageUrls.count
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlAt index: Int) -> URL? {
        let imageURL = URL(string: highQualityImageUrls[index])
        return imageURL
    }
    
    
}

//
//  ScreenRotateController.swift
//  CWPhotoBrowserDemo
//
//  Created by chenwei on 2017/9/2.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
import CWPhotoBrowser

class ScreenRotateController: UIViewController {

    var cell1: PhotoBrowserCell!
    var cell2: PhotoBrowserCell!
    var scrollView: UIScrollView!

    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let imageURL1 = URL(string: "http://7xsmd8.com1.z0.glb.clouddn.com/cwwechat007.jpg")

        let imageURL2 = URL(string: "http://wx3.sinaimg.cn/large/bfc243a3gy1febm7nzbz7j20ib0iek5j.jpg")
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        self.view.addSubview(scrollView)
        
        cell1 = PhotoBrowserCell(frame: self.view.bounds)
        cell1.backgroundColor = UIColor.white
        cell1.imageView.contentMode = .scaleAspectFit
        cell1.setImage(highQualityUrl: imageURL1)
        scrollView.addSubview(cell1)
   
        let origin2 = CGPoint(x: self.view.bounds.width, y: 0)
        let frame2 = CGRect(origin: origin2, size: self.view.bounds.size)
        cell2 = PhotoBrowserCell(frame: frame2)
        cell2.backgroundColor = UIColor.white
        cell2.imageView.contentMode = .scaleAspectFit
        cell2.setImage(highQualityUrl: imageURL2)
        scrollView.addSubview(cell2)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.frame = self.view.bounds
        scrollView.contentSize = CGSize(width: 2*self.view.bounds.width, height: 0)

        cell1.frame = self.view.bounds
        let origin2 = CGPoint(x: self.view.bounds.width, y: 0)
        let frame2 = CGRect(origin: origin2, size: self.view.bounds.size)
        cell2.frame = frame2
        cell2.backgroundColor = UIColor.orange
        
        scrollView.setContentOffset(CGPoint(x: CGFloat(currentIndex)*scrollView.bounds.width, y: 0), animated: false)
        
        print(cell1.frame)
        print(cell2.frame)

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ScreenRotateController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
}



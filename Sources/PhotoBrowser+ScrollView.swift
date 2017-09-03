//
//  PhotoBrowser+ScrollView.swift
//  CWPhotoBrowserDemo
//
//  Created by chenwei on 2017/9/3.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit

public class PhotoBrowser_ScrollView: UIViewController {

    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    public var photoSpace: CGFloat = 30
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
    }
    
    
    
    
    
    
}




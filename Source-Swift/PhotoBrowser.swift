//
//  PhotoBrowser.swift
//  CWPhotoBrowser
//
//  Created by chenwei on 2017/6/28.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit

protocol PhotoBrowserDataSource: NSObjectProtocol {
    
}

extension PhotoBrowserDataSource {
    
}

// 
protocol PhotoBrowserDelegate: NSObjectProtocol {
    func photoBrowser(_ photoBrowser:PhotoBrowser, didSingleTaped index: Int)
    func photoBrowser(_ photoBrowser:PhotoBrowser, didLongPressed index: Int)
}

extension PhotoBrowserDelegate {
    func photoBrowser(_ photoBrowser:PhotoBrowser, didSingleTaped index: Int) {}
    func photoBrowser(_ photoBrowser:PhotoBrowser, didLongPressed index: Int) {}
}


class PhotoBrowser: UIViewController {

    weak var dataSource: PhotoBrowserDataSource?
    weak var delegate: PhotoBrowserDelegate?

    // 可见的cell
    fileprivate var visiblePages: [PhotoScrollView] = [PhotoScrollView]()
    fileprivate var recycledPages: [PhotoScrollView] = [PhotoScrollView]()
    
    var blurEffectBackground: Bool = true
    
    var startIndex: Int = 0
    
    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(_:)))
        return tap
    }()
    
    lazy var doubleTap: UITapGestureRecognizer = {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(_:)))
        doubleTap.numberOfTapsRequired = 2
        return doubleTap
    }()
    
    
    lazy var longPress: UILongPressGestureRecognizer = {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(doubleTapAction(_:)))
        return longPress
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: 复用部分
    
    
    // MARK: 手势事件
    func singleTapAction(_ tap: UITapGestureRecognizer) {
        
    }
    
    func doubleTapAction(_ tap: UITapGestureRecognizer) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 复用照片

}

//
//  PhotoBrowserView.swift
//  CWPhotoBrowserDemo
//
//  Created by chenwei on 2017/9/18.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit

class PhotoBrowserView: UIView {
    
    let padding = CGFloat(10.0)

    var visiblePages = Set<UIImageView>()
    var recycledPages = Set<UIImageView>()
    
    var currentPageIndex: Int = 0
    
    var pageIndexBeforeRotation: Int = 0
    
    var pagingScrollView = UIScrollView()

    var numberOfPhotos: Int = 0
    
    var rotating: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pagingScrollView.isPagingEnabled = true
        pagingScrollView.showsHorizontalScrollIndicator = false
        pagingScrollView.showsVerticalScrollIndicator = false
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        visiblePages.forEach({$0.removeFromSuperview()})
        visiblePages.removeAll()
        recycledPages.removeAll()
    }
    
    func animate(_ frame: CGRect) {
        pagingScrollView.setContentOffset(CGPoint(x: frame.origin.x - padding, y: 0), 
                                          animated: true)
    }
    
}


extension PhotoBrowserView {
    
    func cellForPage(_ index: Int) -> UIImageView {
        let imageView = UIImageView()
        return imageView
    }
    
    
    var frameForPagingScrollView: CGRect {
        var frame = self.bounds// UIScreen.mainScreen().bounds
        frame.origin.x -= padding
        frame.size.width += (2.0 * padding)
        return frame.integral
    }
    
    func frameForPageAtIndex(index: Int) -> CGRect {
        let bounds = pagingScrollView.bounds
        var pageFrame = bounds
        pageFrame.size.width -= (2.0 * padding)
        pageFrame.origin.x = (bounds.size.width * CGFloat(index)) + padding
        return pageFrame.integral
    }
    
    func getFirstIndex() -> Int {
        let firstIndex = Int(floor((bounds.minX + padding * 2) / bounds.width))
        if firstIndex < 0 {
            return 0
        }
        if firstIndex > numberOfPhotos - 1 {
            return numberOfPhotos - 1
        }
        return firstIndex
    }
    
    func getLastIndex() -> Int {
        let lastIndex  = Int(floor((bounds.maxX - padding * 2 - 1) / bounds.width))
        if lastIndex < 0 {
            return 0
        }
        if lastIndex > numberOfPhotos - 1 {
            return numberOfPhotos - 1
        }
        return lastIndex
    }
    
    
    
}

extension PhotoBrowserView: UIScrollViewDelegate {
    
    
    //MARK: - UIScrollView Delegate
    /// UIScrollViewDelegate - scrollViewDidScroll
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Checks
        if rotating {
            return
        }
        
        // Tile pages
        
        // Calculate current page
        let visibleBounds = pagingScrollView.bounds
        var index = Int(floorf(Float(visibleBounds.midX / visibleBounds.width)))
        if index < 0 {
            index = 0
        }
        
  
        
        let previousCurrentPage = currentPageIndex
        currentPageIndex = index
        
      
    }
}


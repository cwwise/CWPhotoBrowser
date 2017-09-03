//
//  ViewController.swift
//  CWPhotoBrowserDemo
//
//  Created by chenwei on 2017/9/2.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit
import CWPhotoBrowser

class IndicatorController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.darkGray
        
        let frame = CGRect(x: 50, y: 150, width: 50, height: 50)
        let progressIndicator = ProgressIndicator(frame: frame)
        self.view.addSubview(progressIndicator)

        
        var progress: CGFloat = 0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            
            if progress > 1.0 {
                timer.invalidate()
            }
            progress += 0.08  
            progressIndicator.progress = progress
        }
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  Indicator.swift
//  CWPhotoBrowserDemo
//
//  Created by chenwei on 2017/9/2.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit

/// 进度指示器
public protocol Indicator {
    var viewCenter: CGPoint { get set }
    var view: UIView { get }
}

extension Indicator {
    public var viewCenter: CGPoint {
        get {
            return view.center
        }
        set {
            view.center = newValue
        }
    }
}

public class ProgressIndicator: UIView {
    
    public var progress: CGFloat = 0 {
        didSet {
            fanshapedLayer.path = makeProgressPath(progress).cgPath
        }
    }    
    
    private var circleLayer: CAShapeLayer

    private var fanshapedLayer: CAShapeLayer
    
    public convenience init() {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.init(frame: frame)
    }

    public override init(frame: CGRect) {
        circleLayer = CAShapeLayer()
        fanshapedLayer = CAShapeLayer()

        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.clear
        let strokeColor = UIColor(white: 1, alpha: 0.8).cgColor
        
        circleLayer.strokeColor = strokeColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.path = makeCirclePath().cgPath
        layer.addSublayer(circleLayer)
        
        fanshapedLayer.fillColor = strokeColor
        layer.addSublayer(fanshapedLayer)
    }
    
    private func makeCirclePath() -> UIBezierPath {
        let arcCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let path = UIBezierPath(arcCenter: arcCenter, radius: 25, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        path.lineWidth = 2
        return path
    }
    
    private func makeProgressPath(_ progress: CGFloat) -> UIBezierPath {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = bounds.midY - 2.5
        let path = UIBezierPath()
        path.move(to: center)
        path.addLine(to: CGPoint(x: bounds.midX, y: center.y - radius))
        path.addArc(withCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: -CGFloat.pi / 2 + CGFloat.pi * 2 * progress, clockwise: true)
        path.close()
        path.lineWidth = 1
        return path
    }
}

extension ProgressIndicator: Indicator {
    
    public var view: UIView {
        return self
    }
    
}


public class TextIndicator: UIView {
    
    private let activityIndicatorView: UIActivityIndicatorView
    
    private let textLabel: UILabel
    
    public override init(frame: CGRect) {
        let indicatorStyle = UIActivityIndicatorViewStyle.gray
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle:indicatorStyle)
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin]
        
        textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 11)
        
        super.init(frame: frame)
        
        self.addSubview(activityIndicatorView)
        self.addSubview(textLabel)
    }
        
    public convenience init() {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}








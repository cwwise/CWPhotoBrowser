//
//  PhotoBrowser.swift
//  CWPhotoBrowserDemo
//
//  Created by chenwei on 2017/9/2.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

public protocol PhotoBrowserDelegate: NSObjectProtocol {
    
    /// 实现本方法以返回图片数量
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int

    /// 实现本方法以返回高质量图片的url。可选
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlAt index: Int) -> URL?
    
    /// 实现本方法以返回默认图所在view，在转场动画完成后将会修改这个view的hidden属性
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewAt index: Int) -> UIImageView?
    
}

public extension PhotoBrowserDelegate {
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlAt index: Int) -> URL? {
        return nil
    }

}



public class PhotoBrowser: UIViewController {

    /// 左右两张图之间的间隙
    public var photoSpace: CGFloat = 30
    
    public var currentIndex: Int = 0

    public weak var photoBrowserDelegate: PhotoBrowserDelegate?
    
    fileprivate var collectionView: UICollectionView!
    
    public var presentingVC: UIViewController!
    
    fileprivate var scaleAnimator: PhotoBrowserScaleAnimator!

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        scaleAnimator = PhotoBrowserScaleAnimator()
        scaleAnimator.delegate = self
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
    
        setupCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveRotate(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

    }
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.view.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true

        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        let indexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    public func show() {
        
        scaleAnimator.index = currentIndex
        self.transitioningDelegate = scaleAnimator
        self.modalPresentationStyle = .custom
        self.modalPresentationCapturesStatusBarAppearance = true
        presentingVC.present(self, animated: true, completion: nil)
        
    }
    
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        } 
        layout.invalidateLayout()
        layout.itemSize = size
    }

    func didReceiveRotate(_ notification: Notification) {
        
        guard let device = notification.object as? UIDevice else {
            return
        }
        print(device.orientation.rawValue)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - UICollectionViewDataSource

extension PhotoBrowser: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let delegate = photoBrowserDelegate else {
            return 0
        }
        return delegate.numberOfPhotos(in: self) 
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoBrowserCell
        cell.delegate = self
        // 高清图url
        let highQualityUrl = imageFor(index: indexPath.row)
        cell.imageView.kf.setImage(with: highQualityUrl)
        
        return cell
    }
    
    private func imageFor(index: Int) -> URL? {
        
        guard let delegate = photoBrowserDelegate else {
            return nil
        }
        
        let highQualityUrl = delegate.photoBrowser(self, highQualityUrlAt: index)

        return highQualityUrl
        
    }
    
}

extension PhotoBrowser: PhotoBrowserCellDelegate {

    func photoBrowserCellDidSingleTap(_ cell: PhotoBrowserCell) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDelegate

extension PhotoBrowser: UICollectionViewDelegate {
    /// 减速完成后，计算当前页
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.bounds.width + photoSpace
        currentIndex = Int(offsetX / width)
    }
}


// MARK: - 转场动画
extension PhotoBrowser: PhotoBrowserScaleAnimatorDelegate {
    
    func presentAnimator(at index : Int) -> (imageView: UIImageView, startRect: CGRect, endRect: CGRect) {
        
        let view = self.photoBrowserDelegate?.photoBrowser(self, thumbnailViewAt: index)

        let imageView = UIImageView(image: view?.image)
        imageView.frame = view!.frame
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        let startFrame = imageView.convert(imageView.bounds, to: self.view)
        let endFrame = self.view.bounds
        
        return (imageView, startFrame, endFrame)
    }
    
    func dismissAnimator(at index : Int) -> (imageView: UIImageView, startRect: CGRect, endRect: CGRect) {
        // 消失的时候 首先根据当前cell 截取一样的view
        let indexPath = IndexPath(row: index, section: 0)
        let cell = collectionView.cellForItem(at: indexPath)! as! PhotoBrowserCell
        
        let endView = self.photoBrowserDelegate?.photoBrowser(self, thumbnailViewAt: index)
        let startFrame = cell.imageView.convert(cell.imageView.bounds, to: self.view)
                
        return (cell.imageView, startFrame, endView!.frame)
    }
    
}
 /*
extension PhotoBrowser: UIViewControllerTransitioningDelegate {
   
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let coordinator = ScaleAnimatorCoordinator(presentedViewController: presented, presenting: presenting)
        coordinator.currentHiddenView = relatedView
        animatorCoordinator = coordinator
        return coordinator
    }

}
  */



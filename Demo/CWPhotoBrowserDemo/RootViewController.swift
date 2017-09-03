//
//  RootViewController.swift
//  CWPhotoBrowserDemo
//
//  Created by chenwei on 2017/9/2.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit
import CWPhotoBrowser

class RootViewController: UITableViewController {

    var dataList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataList = ["进度指示器", "单个图片展示", "屏幕旋转实例", "仿微信聊天列表", "仿微信朋友圈"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataList[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var controller: UIViewController?
        
        switch indexPath.row {
        // 进度
        case 0:
            controller = IndicatorController()
        case 1:
            controller = SingleCellController()
        case 2:
            controller = ScreenRotateController()
        case 3:
            controller = MomentsController()
        default:
            print("点击")
        }
        controller?.title = dataList[indexPath.row]
        if let controller = controller {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

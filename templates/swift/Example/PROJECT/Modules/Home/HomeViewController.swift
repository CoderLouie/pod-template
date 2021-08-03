//
//  HomeViewController.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func setupViews() {
        super.setupViews()
        
        let lbl = UILabel(frame: CGRect(x: 50, y: 100, width: 100, height: 20))
        lbl.localizeKey = Lan.Main.burst
        view.addSubview(lbl)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        OCCallSwiftTest()
        
//        Console.log("begin")
//        Console.benchmark {
//            for _ in 0..<1000 {
//
//            }
//        } completion: {
//            Console.log("end, use \($0)")
//        }

//        present { alert in
//            alert.title = "提示"
//            alert.message = "你确定要这么做吗？"
//            alert.addAction(title: "确定", style: .destructive) {
//                print($0.title!)
//            }
//            alert.addAction(title: "取消", style: .cancel) {
//                print($0.title!)
//            }
//            alert.addAction(title: "默认", style: .default) {
//                print($0.title!)
//            }
//        }

    }
}


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
        lbl.localText = Lan.Home.burst
        view.addSubview(lbl)
    }

}


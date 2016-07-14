//
//  ViewController.swift
//  UIScrollView-ScrollAvailableIndicators
//
//  Created by Konstantin Kabanov on 07/11/2016.
//  Copyright (c) 2016 Konstantin Kabanov. All rights reserved.
//

import UIKit
import UIScrollView_ScrollAvailableIndicators

class ViewController: UIViewController {
	@IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}

	@IBAction func addRecordButtonAction(sender: AnyObject) {
		scrollView.showsVerticalScrollAvailableIndicators = !scrollView.showsVerticalScrollAvailableIndicators
	}
}


//
//  UIScrollView+ScrollAvailableIndicators.swift
//
//	The MIT License (MIT)
//
//	Copyright (c) 2016 Konstantin Kabanov
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.

import ObjectiveC

extension UIScrollView {
	private struct AssociatedKeys {
		static var TopIndicatorView = "kk_TopIndicatorView"
		static var BottomIndicatorView = "kk_BottomIndicatorView"
		static var ShowsVerticalScrollAvailableIndicators = "kk_ShowsVerticalScrollAvailableIndicators"
		static var ScrollAvailableIndicatorsColor = "kk_ScrollAvailableIndicatorsColor"
	}
	
	private var topIndicatorView: UIView! {
		get {
			if let view = objc_getAssociatedObject(self, &AssociatedKeys.TopIndicatorView) as? UIView {
				return view
			}
			
			self.topIndicatorView = UIView()
			self.topIndicatorView.alpha = 0.0
			
			return self.topIndicatorView
		}
		set(newValue) {
			objc_setAssociatedObject(self, &AssociatedKeys.TopIndicatorView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	private var bottomIndicatorView: UIView! {
		get {
			if let view = objc_getAssociatedObject(self, &AssociatedKeys.BottomIndicatorView) as? UIView {
				return view
			}
			
			self.bottomIndicatorView = UIView()
			self.bottomIndicatorView.alpha = 0.0
			
			return self.bottomIndicatorView
		}
		set(newValue) {
			objc_setAssociatedObject(self, &AssociatedKeys.BottomIndicatorView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	@IBInspectable public var showsVerticalScrollAvailableIndicators: Bool {
		get {
			if let shows = objc_getAssociatedObject(self, &AssociatedKeys.ShowsVerticalScrollAvailableIndicators) as? Bool {
				return shows
			}
			
			self.showsVerticalScrollAvailableIndicators = false
			
			return self.showsVerticalScrollAvailableIndicators
		}
		set(newValue) {
			objc_setAssociatedObject(self, &AssociatedKeys.ShowsVerticalScrollAvailableIndicators, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
			
			if self.showsVerticalScrollAvailableIndicators {
				addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
			} else {
				removeObserver(self, forKeyPath: "contentOffset")
			}
			
			contentOffsetDidChange(contentOffset)
		}
	}
	
	@IBInspectable public var scrollAvailableIndicatorsColor: UIColor {
		get {
			if let color = objc_getAssociatedObject(self, &AssociatedKeys.ScrollAvailableIndicatorsColor) as? UIColor {
				return color
			}
			
			self.scrollAvailableIndicatorsColor = UIColor.blackColor()
			
			return self.scrollAvailableIndicatorsColor
		}
		set(newValue) {
			objc_setAssociatedObject(self, &AssociatedKeys.ScrollAvailableIndicatorsColor, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
			
			self.topIndicatorView.backgroundColor = newValue
			self.bottomIndicatorView.backgroundColor = newValue
		}
	}
	
	private var thickness: CGFloat {
		get {
			return 1.0 / UIScreen.mainScreen().scale
		}
	}
	
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if keyPath == "contentOffset" {
			contentOffsetDidChange(contentOffset)
		}
	}
	
	func contentOffsetDidChange(offset: CGPoint) {
		if showsVerticalScrollAvailableIndicators {
			addSubview(topIndicatorView)
			addSubview(bottomIndicatorView)
			
			topIndicatorView.frame = CGRect(x: 0, y: contentOffset.y, width: bounds.width, height: thickness)
			bottomIndicatorView.frame = CGRect(x: 0, y: contentOffset.y + (bounds.height - thickness), width: bounds.width, height: thickness)
			
			if contentOffset.y > 0.0 {
				if topIndicatorView.alpha == 0.0 {
					UIView.animateWithDuration(0.25, animations: {
						self.topIndicatorView.alpha = 1.0
					})
				}
			} else {
				if topIndicatorView.alpha == 1.0 {
					UIView.animateWithDuration(0.25, animations: {
						self.topIndicatorView.alpha = 0.0
					})
				}
			}
			
			if contentOffset.y < (contentSize.height - bounds.height) {
				if bottomIndicatorView.alpha == 0.0 {
					UIView.animateWithDuration(0.25, animations: {
						self.bottomIndicatorView.alpha = 1.0
					})
				}
			} else {
				if bottomIndicatorView.alpha == 1.0 {
					UIView.animateWithDuration(0.25, animations: {
						self.bottomIndicatorView.alpha = 0.0
					})
				}
			}
		} else {
			topIndicatorView.removeFromSuperview()
			bottomIndicatorView.removeFromSuperview()
		}
	}
}
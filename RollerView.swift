//
//  RollerView.swift
//  test2
//
//  Created by 铭 on 2018/11/1.
//  Copyright © 2018 铭 clmd. All rights reserved.
//  卷帘效果

import UIKit

class RollerView: UIView {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    private var subViewHeight: CGFloat = 0.0                // 子视图的高度
    var isShow = false                                      // 是否显示状态
    
    class func sharedInstance(y: CGFloat = 0) -> RollerView {
        let nibView = Bundle.main.loadNibNamed("RollerView", owner: self, options: nil)!.first as! RollerView
        
        nibView.backgroundColor = UIColor.black.withAlphaComponent(0)
        nibView.contentHeight.constant = 0
        nibView.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - y)
        nibView.layoutIfNeeded()
        UIApplication.shared.keyWindow?.addSubview(nibView)
        
        return nibView
    }

    // subView:需要显示的view
    func show(subView: UIView) {
        isShow = true
        subViewHeight = subView.bounds.height
        
        contentHeight.constant = subViewHeight // contentHeight.constant = 0 时添加会出现UI位置异常
        self.layoutIfNeeded()   // 视图预载
        contentView.addSubview(subView)
        contentHeight.constant = 0
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.contentHeight.constant = self.subViewHeight
            self.layoutIfNeeded()
        }
    }
    
    // 同一时间只能调用一次  调了多次容易出现未知的UI行为
    func hidden() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.contentHeight.constant = 0
            self.layoutIfNeeded()
        }) { (finish) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                self.removeFromSuperview()
            }
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        
        if view == self || !getSubViews(view: self).contains(view ?? UIView()) {
            if isShow {
                hidden()
                isShow = !isShow
            }
        }
        
        return view
    }
    
    func getSubViews(view: UIView) -> [UIView] {
        
        if view.subviews.count == 0 {
            return [view]
        } else {
            var subView = [view]
            for item in view.subviews {
                subView.append(contentsOf: getSubViews(view: item))
            }
            return subView
        }
    }
    
    class func hiddenRoller(from view: UIView) {
        if let roller = RollerView.getSuperRollerView(view: view) as? RollerView {
            roller.hidden()
        }
    }
    
    class func getSuperRollerView(view: UIView) -> UIView? {
        if view.isKind(of: RollerView.self) {
            return view
        }else if view.superview == nil {
            return nil
        } else {
            return getSuperRollerView(view: (view.superview ?? UIView()))
        }
    }
    
}

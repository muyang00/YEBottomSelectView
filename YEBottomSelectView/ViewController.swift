//
//  ViewController.swift
//  YEBottomSelectView
//
//  Created by yongen on 2017/9/13.
//  Copyright © 2017年 yongen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func action1(_ sender: UIButton) {
        
       let option1 = SelectViewInfo(title: "退出", color: UIColor.red)
        BottomSelectView.show(title: "是否退出登录", options: [option1], cancelTitle: nil, selectCallBack: { index in
            print(index)
        }){
            print("取消")
        }
    }
   
    @IBAction func action2(_ sender: UIButton) {
        
        let option1 = SelectViewInfo(title: "语音通话", color: nil)
        let option2 = SelectViewInfo(title: "视频聊天", color: nil)
        BottomSelectView.show(title: "请选择聊天方式？", options: [option1, option2], cancelTitle: nil, selectCallBack: { index in
            print(index)
        }){
            print("取消")
        }

        
    }

    @IBAction func action(_ sender: UIButton) {
        
        let option1 = SelectViewInfo(title: "选择1", color: UIColor.green)
        let option2 = SelectViewInfo(title: "选择2", color: UIColor.blue)
        let option3 = SelectViewInfo(title: "选择3", color: UIColor.brown)
        let cancel = SelectViewInfo(title: "取消", color: UIColor.cyan)
        
        BottomSelectView.show(title: "请选择聊天方式？", options: [option1, option2, option3], cancelTitle: cancel, selectCallBack: { index in
            print(index)
        }){
            print("取消")
        }

        
    }

}


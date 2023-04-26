//
//  ViewController.swift
//  UILabelImageText
//
//  Created by chenwuqi on 04/27/2023.
//  Copyright (c) 2023 chenwuqi. All rights reserved.
//

import UIKit
import UILabelImageText

class ViewController: UIViewController {

    @IBOutlet weak var agreeL: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        NSString *imgName = [NSString stringWithFormat:@"%@/%@", @"UILabelImageText.bundle/common_icon_unselected",@"白富美"];
        let pathComponent = "/Frameworks/UILabelImageText.framework/UILabelImageText.bundle"
        let icon_unselected = loadImage(name: "common_icon_unselected", in: pathComponent)
        let icon_selected = loadImage(name: "common_icon_selected", in: pathComponent)
        
        
        agreeL.imageText(normalImage: icon_unselected, selectedImage: icon_selected, content: " 希望您勾选已阅读并同意《用户协议》和《隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议》", font: UIFont.systemFont(ofSize: 12), largeFont: UIFont.systemFont(ofSize: 16), alignment: .left)
        agreeL.setImageCallBack {
            print("点击图标")
            
        }
        
        agreeL.setSubstringCallBack(substring: "《用户协议》") {
            print("《用户协议》")
        }
        
        agreeL.setSubstringCallBack(substring: "《隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议隐私协议》") {
            print("《隐私协议》")
        }
    }
    
    func loadImage(name: String, in pathComponent: String) -> UIImage? {
        guard let resourcePath: String = Bundle.main.resourcePath else { return nil }
        let bundlePath = resourcePath + pathComponent
        let bundle = Bundle(path: bundlePath)
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


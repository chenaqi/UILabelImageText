//
//  UILabel+ImageText.swift
//  ImageTextDemo
//
//  Created by 陈武琦 on 2023/4/21.
//

import UIKit

//MARK: 图文混排，支持点击事件
/// 使用情况：图标可以选中，协议可以点击
public extension UILabel {
    typealias CallBack = (() -> Void)
    
    private struct ImageTextKeys {
        static var imageSelected         = "com.imageText-swift.imageSelected"
        static var normalImage           = "com.imageText-swift.normalImage"
        static var selectedImage         = "com.imageText-swift.selectedImage"
        static var callBackMap           = "com.imageText-swift.callBackMap"
        static var normalImgAttrString   = "com.imageText-swift.normalImgAttrString"
        static var selectedImgAttrString = "com.imageText-swift.selectedImgAttrString"
        static var paragraphStyle        = "com.imageText-swift.paragraphStyle"
        static var largeFont             = "com.imageText-swift.largeFont"
        static var normalFont            = "com.imageText-swift.normalFont"
    }
    
    
    //图标选中状态
    var selected: Bool {
        get { return objc_getAssociatedObject(self, &ImageTextKeys.imageSelected) as? Bool ?? false }
        
        set {
            
            if newValue == selected {
                return
            }
            
            guard let textAttr = attributedText else {
                objc_setAssociatedObject(self, &ImageTextKeys.imageSelected, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                return
            }
            let attributedString = textAttr.mutableCopy() as! NSMutableAttributedString
            if newValue {
                attributedString.replaceCharacters(in: NSRange(location: 0, length: normalImgAttrString.length), with: selectedImgAttrString)
            }else {
                attributedString.replaceCharacters(in: NSRange(location: 0, length: selectedImgAttrString.length), with: normalImgAttrString)
            }
            attributedText = attributedString
            configAttributes()
            objc_setAssociatedObject(self, &ImageTextKeys.imageSelected, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            
        }
        
    }
    
    // 未选中图标
    private var normalImgAttrString: NSAttributedString {
        get { return objc_getAssociatedObject(self, &ImageTextKeys.normalImgAttrString) as? NSAttributedString ?? NSAttributedString()}
        
        set { objc_setAssociatedObject(self, &ImageTextKeys.normalImgAttrString, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    // 选中图标
    private var selectedImgAttrString: NSAttributedString {
        get { return objc_getAssociatedObject(self, &ImageTextKeys.selectedImgAttrString) as? NSAttributedString ?? NSAttributedString()}
        
        set {
            objc_setAssociatedObject(self, &ImageTextKeys.selectedImgAttrString, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    

    private var paragraphStyle: NSMutableParagraphStyle {
        get { return objc_getAssociatedObject(self, &ImageTextKeys.paragraphStyle) as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()}
        
        set {
            objc_setAssociatedObject(self, &ImageTextKeys.paragraphStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    private var largeFont: UIFont {
        get { return objc_getAssociatedObject(self, &ImageTextKeys.largeFont) as? UIFont ?? UIFont.systemFont(ofSize: 20)}
        
        set {
            objc_setAssociatedObject(self, &ImageTextKeys.largeFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    private var normalFont: UIFont {
        get { return objc_getAssociatedObject(self, &ImageTextKeys.normalFont) as? UIFont ?? UIFont.systemFont(ofSize: 12)}
        
        set {
            objc_setAssociatedObject(self, &ImageTextKeys.normalFont, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    
    
    private var callBackMap: [String:CallBack]? {
        get { return objc_getAssociatedObject(self, &ImageTextKeys.callBackMap) as? [String:CallBack] ?? [String:CallBack]()}
        
        set { objc_setAssociatedObject(self, &ImageTextKeys.callBackMap, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    
    func imageText(normalImage: UIImage? = nil,
                   selectedImage: UIImage? = nil,
                   content: String? = nil,
                   font: UIFont = UIFont.systemFont(ofSize: 12),
                   largeFont: UIFont = UIFont.systemFont(ofSize: 20),
                   alignment: NSTextAlignment = .left) {
        
        if normalImage == nil && selectedImage == nil && content == nil {
            assert(true, "参数全为空")
        }
        
        let muAttributedString = NSMutableAttributedString()
        
        if let normalImage = normalImage {
            let attachment = NSTextAttachment()
            attachment.image = normalImage
            normalImgAttrString = NSAttributedString(attachment: attachment)
            muAttributedString.append(normalImgAttrString)
        }
        
        if let selectedImage = selectedImage {
            let attachment = NSTextAttachment()
            attachment.image = selectedImage
            selectedImgAttrString = NSAttributedString(attachment: attachment)
        }
        
        if let content = content {
            muAttributedString.append(NSAttributedString(string: content))
        }
        
        self.normalFont = font
        self.largeFont = largeFont
        paragraphStyle.alignment = alignment
        attributedText = muAttributedString
        configAttributes()
        addGesture()
        
    }
    
    
    
    func setImageCallBack(clicked: @escaping () -> Void) {
        callBackMap?[normalImgAttrString.string] = clicked
        callBackMap?[selectedImgAttrString.string] = clicked
    }
    
    func setSubstringCallBack(substring: String, color: UIColor = .gray, clicked: @escaping () -> Void) {
        guard let textAttr = attributedText else {
            return
        }
        
        let attributedString = textAttr.mutableCopy() as! NSMutableAttributedString
        let range = attributedString.mutableString.range(of: substring)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
        attributedText = attributedString
        callBackMap?[substring] = clicked
    }
    
    
    // 段落设置
    private func configAttributes() {
        guard let textAttr = attributedText else {
            return
        }
        
        let muAttributedString = textAttr.mutableCopy() as! NSMutableAttributedString
        
        muAttributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                          NSAttributedString.Key.font: normalFont],
                                         range: NSRange(location: 0, length: muAttributedString.length))
        
        if normalImgAttrString.length > 0 {
            
            //适用于图片的大小等于点击区域
//            let baselineOffset = (largeFont.lineHeight - normalFont.lineHeight)/2.0
            //适用于图片的小于点击区域
            let baselineOffset = (largeFont.lineHeight - normalFont.lineHeight)/2.0 + (largeFont.descender - normalFont.descender)
            muAttributedString.addAttributes([
                                              NSAttributedString.Key.baselineOffset: baselineOffset],
                                             range: NSRange(location: normalImgAttrString.length, length: muAttributedString.length - normalImgAttrString.length))
            
        }else {
            muAttributedString.addAttributes([NSAttributedString.Key.font: normalFont],
                                             range: NSRange(location: 0, length: muAttributedString.length))
        }
        
        attributedText = muAttributedString
    }
    
    
    //添加点击手势
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer()
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(click))
    }
    
    
    // 点击响应
    @objc
    private func click(_ gesture: UITapGestureRecognizer) {
        
        guard let dict = callBackMap else {
            return
        }
        
        let point = gesture.location(in: self)
        for key in dict.keys {
            guard let (rect1, rect2) = rectFor(string: key) else {
                return
            }
            let imgString = selected ? selectedImgAttrString : normalImgAttrString
            
            if containsPoint(minRect: rect1, maxRect: key == imgString.string ? CGRect(x: 0, y: 0, width: largeFont.pointSize, height: largeFont.pointSize):rect2, point: point) {
                
                if key == imgString.string {
                    selected = !selected
                }
                if let callBack = dict[key] {
                    callBack()
                }
            }
        }
        
    }
    
    private func containsPoint(minRect:CGRect, maxRect: CGRect, point: CGPoint) -> Bool {
        let midHeight = maxRect.minY - minRect.maxY > 0 ? maxRect.minY - minRect.maxY : 0
        let midRect = CGRect(x: 0, y: minRect.maxY, width: bounds.width, height: midHeight)
        return minRect.contains(point) ||
               midRect.contains(point) ||
               maxRect.contains(point)
    }
        
}

extension UILabel
{
    // 查找字串的rect
    func rectFor(string str : String, fromIndex: Int = 0) -> (CGRect, CGRect)?
    {
        // Find the range of the string
        guard self.text != nil else { return nil }
        let subStringToSearch : NSString = (self.text! as NSString).substring(from: fromIndex) as NSString
        var stringRange = subStringToSearch.range(of: str)
        if (stringRange.location != NSNotFound)
        {
            guard self.attributedText != nil else { return nil }
            // Add the starting point to the sub string
            stringRange.location += fromIndex
            let storage = NSTextStorage(attributedString: self.attributedText!)
            let layoutManager = NSLayoutManager()
            storage.addLayoutManager(layoutManager)
            let textContainer = NSTextContainer(size: self.frame.size)
            textContainer.lineFragmentPadding = 0
            textContainer.lineBreakMode = .byWordWrapping
            layoutManager.addTextContainer(textContainer)
            var glyphRange = NSRange()
            
            layoutManager.characterRange(forGlyphRange: stringRange, actualGlyphRange: &glyphRange)
            var firstWordRect = true
            var rect1 = CGRectZero
            var rect2 = CGRectZero
            layoutManager.enumerateEnclosingRects(forGlyphRange: glyphRange, withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 1), in: textContainer) { wordRect, isStop in
                print("_____wordRect:\(wordRect)")
                if firstWordRect {
                    rect1 = wordRect
                    firstWordRect = false
                }
                
                rect2 = wordRect
            }
            
            return (rect1, rect2)
        }
        return nil
    }
}



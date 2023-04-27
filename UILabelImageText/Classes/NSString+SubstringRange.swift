//
//  NSString+SubstringRange.swift
//  UILabelImageText
//
//  Created by 陈武琦 on 2023/4/27.
//

import Foundation

extension NSString {
    
    func allRanges(substring: String) -> [NSRange]? {
        var ranges = [NSRange]()
        rangeOf(str: substring, ranges: &ranges, fromIndex: 0)
        if ranges.count > 0 {
            return ranges
        }
        return nil
    }
    
    func rangeOf(str: String, ranges:inout [NSRange], fromIndex: Int) {
        if fromIndex >= length - str.count {
            return
        }
        
        let subStringToSearch : NSString = substring(from: fromIndex) as NSString
        var stringRange = subStringToSearch.range(of: str)
        
        if (stringRange.location != NSNotFound)
        {
            stringRange.location += fromIndex
            ranges.append(stringRange)
            rangeOf(str: str, ranges: &ranges, fromIndex:  stringRange.location + str.count)
        }
        
    }
    
    
//    //通过递归获取所有子字符串location
//    - (void)rangeOfString:(NSString*)searchString fatherString:(NSString*)fatherStr options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch {
//    //获取指定范围内第一个匹配的子字符串rang，和上面NSRegularExpression的一个方法效果一样NSRange rang = [fatherStr rangeOfString:searchString options:mask range:rangeOfReceiverToSearch];//判断搜寻范围来决定是否完成搜寻
//        if (rang.location >fatherStr.length - searchString.length) {
//            return;
//        }//NSRang不能存储在数组中，所以这里存的是rang的location
//        [strLocationRangArr addObject:[NSNumber numberWithInteger:rang.location]];//递归搜寻
//        [self rangeOfString:searchString fatherString:fatherStr options:mask range:NSMakeRange(rang.location+searchString.length, fatherStr.length-rang.location-searchString.length)];
//    }
    
}

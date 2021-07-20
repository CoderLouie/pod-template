//
//  String+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation

public extension String {
    /// 是否是邮箱
    func isEmail() -> Bool {
        return isMatch(regEx: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
    }

    /// 是否是的验证码
    /// 数字、英语结合，8个字符
    func isCaptcha() -> Bool {
        return isMatch(regEx: "[a-zA-Z0-9]{8}")
    }
    
    func isMatch(regEx: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regEx).evaluate(with: self)
    }
}

public extension String {
    var bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
}

public extension String {
    func group(by size: Int) -> [String] {
        var res: [String] = []
        var index = self.startIndex
        while index != self.endIndex {
            let startIdx = index
            let endIdx = self.index(startIdx, offsetBy: size, limitedBy: self.endIndex) ?? self.endIndex
            res.append(String(self[startIdx..<endIdx]))
            index = endIdx
        }
        return res
    }
}

public extension String {
    func compareVersion(_ version: String) -> ComparisonResult {
        guard !version.isEmpty else { return .orderedDescending }
        let set = CharacterSet.decimalDigits.inverted
        let nums1 = components(separatedBy: set)
        let nums2 = version.components(separatedBy: set)
        for i in 0..<min(nums1.count, nums2.count) {
            guard let num1 = Int(nums1[i]) else { return .orderedAscending }
            guard let num2 = Int(nums2[i]) else { return .orderedDescending }
            guard num1 != num2 else { continue }
            return num1 < num2 ? .orderedAscending : .orderedDescending
        }
        if nums1.count == nums2.count { return .orderedSame }
        return nums1.count < nums2.count ? .orderedAscending : .orderedDescending
    }
}

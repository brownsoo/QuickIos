//
//  StringExtension.swift
//  StudioBase
//
//  Created by brownsoo han on 2017. 12. 21..
//  Copyright © 2017년 StudioMate. All rights reserved.
//

import Foundation


public extension String {
    func striked(color: UIColor = QuickColor.charcoalGrey) -> NSAttributedString {
        return NSAttributedString(string: self,
                                  attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                               NSAttributedString.Key.strikethroughColor: QuickColor.charcoalGrey])
    }
    func mutable(fontSize: CGFloat? = nil) -> NSMutableAttributedString {
        if let size = fontSize {
            return NSMutableAttributedString(string: self,
                                             attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size)])
        }
        return NSMutableAttributedString(string: self)
    }
}

public extension NSMutableAttributedString {
    func bold(fontSize: CGFloat? = nil) -> NSMutableAttributedString {
        let font = self.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil) as? UIFont
        let size = fontSize ?? font?.pointSize ?? 12
        return NSMutableAttributedString(string: self.string,
                                         attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: .bold)])
    }
    func regular(fontSize: CGFloat? = nil) -> NSMutableAttributedString {
        let font = self.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil) as? UIFont
        let size = fontSize ?? font?.pointSize ?? 12
        return NSMutableAttributedString(string: self.string,
                                         attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: size, weight: .regular)])
    }
}

public extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

public extension String {
    /// new sub string
    func from(_ start: Int, until end: Int) -> String? {
        if start < self.count && start > -1 {
            let si = self.index(self.startIndex, offsetBy: start)
            let ei: String.Index
            if end < 0 || end >= self.count {
                ei = self.endIndex
            } else {
                ei = self.index(self.startIndex, offsetBy: end)
            }
            return String(self[si..<ei])
        } else {
            return nil
        }
    }

    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString,
            options: NSString.CompareOptions.literal, range: nil)
    }
}

// extension for validation

public extension String {

    var hasOnlyNumber: Bool {
        if self.isEmpty {
            return false
        }
        do {
            let pattern = "[^0-9]"
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)).count == 0
        } catch {
            return false
        }
    }

    var isCellularPhoneFormat: Bool {
        if self.isEmpty || !self.hasOnlyNumber {
            return false
        }
        do {
            let pattern = "(01)[0,1,6,7,8,9][0-9]{7,8}"
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)).count > 0
        } catch {
            return false
        }
    }

    var isEmailFormat: Bool {
        if self.isEmpty {
            return false
        }
        do {
            let pattern = "^(([^<>()\\[\\]\\\\.,;:\\s@\"]" +
                "+(\\.[^<>()\\[\\]\\\\.,;:\\s@\"]+)*)|(\".+\"))" +
                "@" +
                "((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}])" +
                "|(([a-zA-Z-0-9]+\\.)+[a-zA-Z]{2,}))$"
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)).count > 0
        } catch {
            return false
        }
    }

    var hasOnlyAlphabetOrNumber: Bool {
        if self.isEmpty {
            return false
        }
        do {
            let pattern = "[^a-zA-Z0-9]"
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)).count == 0
        } catch {
            return false
        }
    }

    var hasNumber: Bool {
        if self.isEmpty {
            return false
        }
        do {
            let pattern = "[0-9]+"
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)).count > 0
        } catch {
            return false
        }
    }

    var hasAlphabet: Bool {
        if self.isEmpty {
            return false
        }
        do {
            let pattern = "[a-zA-Z]+"
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)).count > 0
        } catch {
            return false
        }
    }

    /// 다음 문자를 포함하는지 여부
    /// !  @  #  $  &  (  )  -  ‘  .  /  +  ,  “ ^ 공백
    var hasSpecialChar: Bool {
        if self.isEmpty {
            return false
        }
        do {
            let pattern = "[*\\^\\s!@#$&()\\-`.+,/\"]+"
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)).count > 0
        } catch {
            return false
        }
    }

    func toAppIdentifier() -> String {
        return "mate-user-\(self.prefix(20))"
    }
}

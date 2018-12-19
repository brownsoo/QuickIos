//
//  UIKitExtension.swift
//  QuickIosComponent
//
//  Created by brownsoo han on 2017. 11. 8..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import UIKit
import QuartzCore

public extension UIApplication {
    
    public class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    public class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    public class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
}


public extension UIColor {
    
    public func alpha(_ a: CGFloat) -> UIColor {
        return self.withAlphaComponent(a)
    }

    public func brightness(brightness: CGFloat) -> UIColor {
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        if getHue(&H, saturation: &S, brightness: &B, alpha: &A) {
            //B += (brightness - 1.0)
            B = max(min(brightness, 1.0), 0.0)

            return UIColor(hue: H, saturation: S, brightness: B, alpha: A)
        }
        return self
    }
    
    public var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
    
    public convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid red component")
        assert(blue >= 0 && blue <= 255, "Invalid red component")
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
    public convenience init(rgb: Int) {
        self.init(red: (rgb >> 16) & 0xff,
                  green: (rgb >> 8) & 0xff,
                  blue: rgb & 0xff)
    }
    public func toImage(width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { c in
            self.setFill()
            c.fill(CGRect(origin: CGPoint(), size: size))
        }
    }
}

public extension UIView {
    
    var compatTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    var compatBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
    
    var compatCenterXAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerXAnchor
        } else {
            return self.centerXAnchor
        }
    }
    
    var compatCenterYAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerYAnchor
        } else {
            return self.centerYAnchor
        }
    }
    
    /// 디버깅용: 보더에 아웃라인을 그린다.
    public func drawOutline(_ color: UIColor = UIColor.red, fill: Bool = false) {
        self.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        self.layer.borderWidth = 0.3
        if fill {
            self.layer.backgroundColor = color.withAlphaComponent(0.2).cgColor
        }
        for child in self.subviews {
            child.layer.borderColor = color.withAlphaComponent(0.5).cgColor
            child.layer.borderWidth = 1
            if fill {
                self.layer.backgroundColor = color.withAlphaComponent(0.2).cgColor
            }
        }
    }

    public func toImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { context in
                layer.render(in: context.cgContext)
            }
        } else {
            let rect = self.frame
            UIGraphicsBeginImageContext(rect.size)
            if let context = UIGraphicsGetCurrentContext() {
                self.layer.render(in: context)
                let img = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return img
            }
            return nil
        }
    }
    
    @discardableResult
    public func addTap(_ target: Any, action: Selector) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        return tap
    }
}

public extension UIImage {
    @discardableResult
    func tint(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let result = renderer.image { c in
            color.setFill()
            c.fill(rect)
            self.draw(in: rect, blendMode: .destinationIn, alpha: 1)
        }
        return result
    }

    @discardableResult
    func solid(_ color: UIColor) -> UIImage {
        let rect  = CGRect(x: 0, y: 0, width: 1, height: 1)
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let result = renderer.image { c in
            color.setFill()
            c.fill(rect)
        }
        return result
    }

    @discardableResult
    func round(_ radius: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let result = renderer.image { c in
            let rounded = UIBezierPath(roundedRect: rect, cornerRadius: radius)
            rounded.addClip()
            if let cgImage = self.cgImage {
                UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation).draw(in: rect)
            }
        }
        return result
    }
    @discardableResult
    func circle() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let result = renderer.image { c in
            let isPortrait = size.height > size.width
            let isLandscape = size.width > size.height
            let breadth = min(size.width, size.height)
            let breadthSize = CGSize(width: breadth, height: breadth)
            let breadthRect = CGRect(origin: .zero, size: breadthSize)
            let origin = CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0,
                                 y: isPortrait  ? floor((size.height - size.width) / 2) : 0)
            let circle = UIBezierPath(ovalIn: breadthRect)
            circle.addClip()
            if let cgImage = self.cgImage?.cropping(to: CGRect(origin: origin, size: breadthSize)) {
                UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation).draw(in: rect)
            }
        }
        return result
    }
    
    @discardableResult
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let newRect = CGRect(origin: CGPoint(), size: newSize)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let result = renderer.image { c in
            self.draw(in: newRect)
        }
        return result
    }
}

extension UIViewController {
    /// DispatchQueue.main.async 으로 전달
    public func runOnMain(_ block:@escaping ()->Void) {
        self.runOnMain(block, delay: 0)
    }
    /// DispatchQueue.main.asyncAfter 로 전달
    public func runOnMain(_ block:@escaping ()->Void, delay: TimeInterval) {
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                block()
            }
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
    /// 네비게이션을 pop 하거나 presented 뷰를 dismiss 한다.
    open func dismissEasy() {
        DispatchQueue.main.async {
            if let nc = self.navigationController {
                nc.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func pushOrPresent(_ vc: UIViewController, animated: Bool) {
        if let nc = navigationController {
            nc.pushViewController(vc, animated: animated)
        } else {
            present(vc, animated: animated, completion: nil)
        }
    }
}

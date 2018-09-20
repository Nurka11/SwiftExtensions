//
//  Extensions.swift
//  SwiftExtensions
//
//  Created by Nurzhan Ormanali on 03.08.2018.
//  Copyright © 2018 Nurzhan Ormanali. All rights reserved.
//

import UIKit

//    MARK: UIView extensions
extension UIView {
    func addSubViews(views: [UIView]) {
        views.forEach({ self.addSubview($0) })
    }
    
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    public var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    public func addShadow(ofColor color: UIColor, radius: CGFloat, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
}

//    MARK: UIViewController extensions
extension UIViewController {
    
    func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }
        
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                alertController.preferredAction = action
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height-100, width: self.view.bounds.width - 40, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showActivityIndicator() {
        
        let blackView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        blackView.tag = 123
        blackView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubViews(views: [blackView, activityIndicator])
        
    }
    
    func hideActivityIndicator() {
        
        let blackView = self.view.subviews.first(where: {
            return $0.tag == 123
        })
        blackView?.removeFromSuperview()
        
        let activityIndicator = self.view.subviews.first(where: {
            return $0 is UIActivityIndicatorView
        })
        activityIndicator?.removeFromSuperview()
        
    }
    
    func activityIndicatorIsset() -> Bool {
        let activityIndicator = self.view.subviews.first(where: {
            return $0 is UIActivityIndicatorView
        })
        if activityIndicator != nil {
            return true
        }
        return false
    }
    
}
//    MARK: Date extensions
extension Date {
    
    func getDateFormat() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: self)
        
        return dateString
    }
    
    func getTimeFormat() -> String {
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let timeString = timeFormatter.string(from: self)
        
        return timeString
    }
    
}

//    MARK: String extensions
extension String {
    
    func getTime(from FromDateFormat: String, to ToDateFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FromDateFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: self)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = ToDateFormat
        timeFormatter.timeZone = TimeZone(identifier: "UTC")
        let time = timeFormatter.string(from: date!)
        
        return time
    }
    
    func stringHeight(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: UIScreen.main.bounds.width * 0.7, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union( .usesLineFragmentOrigin )
        let estimatedSize = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : font], context: nil)
        
        return estimatedSize
    }
    
}

//    MARK: UINavigationBar extensions
extension UINavigationBar {
    
    public func setTitleFont(_ font: UIFont, color: UIColor = .black) {
        var attrs = [NSAttributedStringKey: Any]()
        attrs[.font] = font
        attrs[.foregroundColor] = color
        titleTextAttributes = attrs
    }
    
    public func makeTransparent(withTint tint: UIColor = .white) {
        isTranslucent = true
        backgroundColor = .clear
        barTintColor = .clear
        setBackgroundImage(UIImage(), for: .default)
        tintColor = tint
        titleTextAttributes = [.foregroundColor: tint]
        shadowImage = UIImage()
    }
    
    public func setColors(background: UIColor, text: UIColor) {
        isTranslucent = false
        backgroundColor = background
        barTintColor = background
        setBackgroundImage(UIImage(), for: .default)
        tintColor = text
        titleTextAttributes = [.foregroundColor: text]
    }
    
}

//    MARK: UINavigationController extensions
extension UINavigationController {
    
    public func navigationSetups(title: String, navViewColor: UIColor, navTintColor: UIColor, backTitle: String) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: backTitle, style: .done, target: self, action: nil)
        //navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = navTintColor
        navigationController?.navigationBar.barTintColor = navViewColor
    }
    
    public func setTitleView(titleText: String, titleImage: UIImage) {
        
        let titleView = UIView()
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.3, height: label.frame.size.height)
        label.text = titleText
        label.sizeToFit()
        label.center = titleView.center
        label.textAlignment = NSTextAlignment.center
        
        let image = UIImageView()
        image.image = titleImage
        
        let imageAspect = image.image!.size.width / image.image!.size.height
        
        image.frame = CGRect(x: label.frame.origin.x - label.frame.size.height * imageAspect, y: label.frame.origin.y, width: label.frame.size.height * imageAspect, height: label.frame.size.height)
        image.contentMode = UIViewContentMode.scaleAspectFit
        
        titleView.addSubview(label)
        titleView.addSubview(image)
        
        self.navigationItem.titleView = titleView
        
        titleView.sizeToFit()
        
    }
    
}

//    MARK: Collection extensions
extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//    MARK: UITextView extensions
extension UITextView {
    
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}

//    MARK: UIColor extensions
extension UIColor {
    static func hexStringToUIColor (hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//    MARK: UIStackView extensions
extension UIStackView {
    func addArrangedSubViews(views: [UIView]) {
        views.forEach({ self.addArrangedSubview($0) })
    }
}

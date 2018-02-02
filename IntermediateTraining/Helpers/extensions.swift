//
//  UIColor+theme.swift
//  IntermediateTraining
//
//  Created by Paul Dong on 13/01/18.
//  Copyright © 2018 Paul Dong. All rights reserved.
//

import UIKit

extension UIColor {
    /**
     Initializes and returns a color object using the specified RGB component values.
     */
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let teelColor = UIColor(r: 48, g: 164, b: 182)
    static let lightRed = UIColor(r: 247, g: 66, b: 82)
    static let darkBlue = UIColor(r: 9, g: 45, b: 64)
    static let lightBlue = UIColor(r: 218, g: 235, b: 243)
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = .white
        self.navigationBar.barTintColor = .lightRed
        self.navigationBar.prefersLargeTitles = true
        
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationBar.titleTextAttributes = titleTextAttributes
        self.navigationBar.largeTitleTextAttributes = titleTextAttributes
    }
}

extension UITableViewController {
    func setBackButtonTitle(_ title: String) {
        let backBarButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
    }
}

extension UIViewController {
    
    func setupPlusButton(_ selector: Selector){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: .plain, target: self, action: selector)
    }
    
    func setupResetButton(_ selector: Selector){
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: selector)
        navigationItem.leftBarButtonItem = resetButton
    }
    
    func setupSaveButton(_ selector: Selector){
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: selector)
        saveButton.tintColor = .white
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func setupLightBlueBackgroundView(_ margins: UILayoutGuide, height: CGFloat) -> UIView {
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return lightBlueBackgroundView
    }
}

extension Date {
    static func get(dateString: String, format: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
    
    func dateString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func localDateString(_ style: DateFormatter.Style) -> String {
        let locale = Locale.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        dateFormatter.locale = locale
        return dateFormatter.string(from: self)
    }
}

extension Company {
    
    func setInitial() {
        if let name = self.name, let initial = name.first  {
            self.initial = (String(initial)).uppercased()
        }
    }
}

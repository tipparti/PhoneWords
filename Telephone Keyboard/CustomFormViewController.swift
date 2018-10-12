//
//  CustomFormViewController.swift
//  Telephone Keyboard
//
//  Created by mobility on 10/12/18.
//  Copyright © 2018 TMobil. All rights reserved.
//

import Foundation
import UIKit

class CustomFormViewController: UIViewController {
    
}



class CustomStackedFormView: UIView {
    
    lazy private var heading: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.gray
        label.font = UIFont(name: "SFProText-Regular", size: 14)!
        label.text = "Heading Field"
        return label
    }()
    
    lazy private var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.text = ""
        textField.keyboardType = .default
        textField.setBottomBorder()
        return textField
    }()
    
    lazy private var verticalView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var isRequired: Bool = true
    
    convenience init(frame: CGRect, heading: String, isRequired: Bool = true, keyBoardType: UIKeyboardType = .default) {
        self.init(frame: frame)
        self.heading.text = heading
        self.textField.keyboardType = keyBoardType
        self.isRequired = isRequired
        self.setupLayout()
    }
    
    fileprivate func setupLayout() {
        self.addSubview(verticalView)
        self.verticalView.addSubview(heading)
        self.verticalView.addSubview(textField)
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
